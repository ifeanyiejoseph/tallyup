;; Tallyup - Job Offer Smart Contract

(define-data-var admin principal tx-sender)
(define-data-var next-job-id uint u1)

(define-map jobs 
  uint
  {
    client: principal,
    freelancer: (optional principal),
    budget: uint,
    description: (buff 256),
    status: uint
  }
)

;; Job Status Enum
(define-constant STATUS-OPEN u0)
(define-constant STATUS-ASSIGNED u1)
(define-constant STATUS-COMPLETED u2)
(define-constant STATUS-CANCELLED u3)
(define-constant STATUS-PAID u4)

;; Error codes
(define-constant ERR-NOT-FOUND u100)
(define-constant ERR-NOT-AUTHORIZED u101)
(define-constant ERR-INVALID-STATUS u102)
(define-constant ERR-JOB-ALREADY-TAKEN u103)
(define-constant ERR-JOB-NOT-COMPLETED u104)

;; Admin check
(define-private (is-admin (caller principal))
  (is-eq caller (var-get admin))
)

;; Read job
(define-read-only (get-job (job-id uint))
  (match (map-get? jobs job-id)
    some-job (ok some-job)
    none (err ERR-NOT-FOUND)
  )
)

;; Create a job
(define-public (create-job (budget uint) (description (buff 256)))
  (let ((id (var-get next-job-id)))
    (begin
      (map-set jobs id {
        client: tx-sender,
        freelancer: none,
        budget: budget,
        description: description,
        status: STATUS-OPEN
      })
      (var-set next-job-id (+ id u1))
      (ok id)
    )
  )
)

;; Cancel job
(define-public (cancel-job (job-id uint))
  (match (map-get? jobs job-id)
    some-job
      (begin
        (asserts! (is-eq tx-sender (get client some-job)) (err ERR-NOT-AUTHORIZED))
        (asserts! (is-eq (get status some-job) STATUS-OPEN) (err ERR-INVALID-STATUS))
        (map-set jobs job-id (merge some-job { status: STATUS-CANCELLED }))
        (ok true)
      )
    none (err ERR-NOT-FOUND)
  )
)

;; Accept job
(define-public (accept-job (job-id uint))
  (match (map-get? jobs job-id)
    some-job
      (begin
        (asserts! (is-eq (get status some-job) STATUS-OPEN) (err ERR-JOB-ALREADY-TAKEN))
        (map-set jobs job-id (merge some-job {
          freelancer: (some tx-sender),
          status: STATUS-ASSIGNED
        }))
        (ok true)
      )
    none (err ERR-NOT-FOUND)
  )
)

;; Complete job
(define-public (complete-job (job-id uint))
  (match (map-get? jobs job-id)
    some-job
      (begin
        (asserts!
          (is-eq tx-sender (unwrap! (get freelancer some-job) (err ERR-NOT-AUTHORIZED)))
          (err ERR-NOT-AUTHORIZED)
        )
        (asserts! (is-eq (get status some-job) STATUS-ASSIGNED) (err ERR-INVALID-STATUS))
        (map-set jobs job-id (merge some-job { status: STATUS-COMPLETED }))
        (ok true)
      )
    none (err ERR-NOT-FOUND)
  )
)

;; Mark job as paid (by client)
(define-public (mark-paid (job-id uint))
  (match (map-get? jobs job-id)
    some-job
      (begin
        (asserts! (is-eq tx-sender (get client some-job)) (err ERR-NOT-AUTHORIZED))
        (asserts! (is-eq (get status some-job) STATUS-COMPLETED) (err ERR-JOB-NOT-COMPLETED))
        (map-set jobs job-id (merge some-job { status: STATUS-PAID }))
        ;; Future: Transfer tokens here
        (ok true)
      )
    none (err ERR-NOT-FOUND)
  )
)

;; Admin transfer
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin tx-sender) (err ERR-NOT-AUTHORIZED))
    (var-set admin new-admin)
    (ok true)
  )
)
