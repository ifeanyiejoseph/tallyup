import { describe, it, expect, beforeEach } from "vitest"

const mockContract = {
  admin: "ST1ADMIN",
  nextJobId: 1,
  jobs: new Map(),

  createJob(caller: string, budget: number, description: string) {
    const jobId = this.nextJobId++
    this.jobs.set(jobId, {
      client: caller,
      freelancer: null,
      budget,
      description,
      status: 0, // STATUS-OPEN
    })
    return { value: jobId }
  },

  cancelJob(caller: string, jobId: number) {
    const job = this.jobs.get(jobId)
    if (!job) return { error: 100 }
    if (job.client !== caller) return { error: 101 }
    if (job.status !== 0) return { error: 102 }
    job.status = 3 // STATUS-CANCELLED
    return { value: true }
  },

  acceptJob(caller: string, jobId: number) {
    const job = this.jobs.get(jobId)
    if (!job) return { error: 100 }
    if (job.status !== 0) return { error: 103 }
    job.freelancer = caller
    job.status = 1 // STATUS-ASSIGNED
    return { value: true }
  },

  completeJob(caller: string, jobId: number) {
    const job = this.jobs.get(jobId)
    if (!job) return { error: 100 }
    if (job.freelancer !== caller) return { error: 101 }
    if (job.status !== 1) return { error: 102 }
    job.status = 2 // STATUS-COMPLETED
    return { value: true }
  },

  markPaid(caller: string, jobId: number) {
    const job = this.jobs.get(jobId)
    if (!job) return { error: 100 }
    if (job.client !== caller) return { error: 101 }
    if (job.status !== 2) return { error: 104 }
    job.status = 4 // STATUS-PAID
    return { value: true }
  },
}

describe("Tallyup Job Offer Contract", () => {
  beforeEach(() => {
    mockContract.admin = "ST1ADMIN"
    mockContract.jobs = new Map()
    mockContract.nextJobId = 1
  })

  it("should create a job", () => {
    const result = mockContract.createJob("ST1CLIENT", 500, "Build a dApp")
    expect(result.value).toBe(1)
  })

  it("should accept a job", () => {
    const id = mockContract.createJob("ST1CLIENT", 500, "Task").value
    const result = mockContract.acceptJob("ST1FREELANCER", id)
    expect(result.value).toBe(true)
  })

  it("should not accept a job twice", () => {
    const id = mockContract.createJob("ST1CLIENT", 500, "Task").value
    mockContract.acceptJob("ST1FREELANCER", id)
    const result = mockContract.acceptJob("ST1OTHER", id)
    expect(result.error).toBe(103)
  })

  it("should complete job by freelancer", () => {
    const id = mockContract.createJob("ST1CLIENT", 500, "Task").value
    mockContract.acceptJob("ST1FREELANCER", id)
    const result = mockContract.completeJob("ST1FREELANCER", id)
    expect(result.value).toBe(true)
  })

  it("should mark job paid by client", () => {
    const id = mockContract.createJob("ST1CLIENT", 500, "Task").value
    mockContract.acceptJob("ST1FREELANCER", id)
    mockContract.completeJob("ST1FREELANCER", id)
    const result = mockContract.markPaid("ST1CLIENT", id)
    expect(result.value).toBe(true)
  })
})
