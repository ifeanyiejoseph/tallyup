# Tallyup: Decentralized Freelance & Gig Reputation Network

A blockchain-based platform for managing freelance contracts, trustless payments, and on-chain reputation in the gig economy — empowering freelancers and clients to collaborate securely, transparently, and without intermediaries.

## Overview

Tallyup is composed of 9 core smart contracts that together enable a robust, decentralized infrastructure for gig-based work. The system supports end-to-end workflows — from offer creation to payment release and dispute resolution.

### Smart Contracts:

1. **Profile Registry Contract** – On-chain identity and skill verification
2. **Job Offer Contract** – Task posting and scoping by clients
3. **Proposal & Bidding Contract** – Freelancers submit bids, rates, and delivery timelines
4. **Escrow & Payment Contract** – Secure, trustless fund management
5. **Milestone Contract** – Enables milestone-based work and partial payouts
6. **Review & Reputation Contract** – Immutable feedback and rating history
7. **Dispute Resolution Contract** – DAO-based arbitration and resolution
8. **Certification Contract** – Skill attestation and verifiable credentials
9. **Incentives & Staking Contract** – Token incentives, staking for trust, slashing for fraud

## Features

- Fully decentralized gig management
- Transparent escrow-backed payments
- Immutable on-chain reviews and ratings
- DAO-based dispute arbitration
- Token-based incentives for quality contributions
- Skill credentialing via certifications
- Milestone-based work enforcement
- On-chain identity and proof-of-reputation

## Smart Contracts

### Profile Registry Contract

- Create and update freelancer/client profiles
- Link social accounts and portfolio
- Associate certifications and work history

### Job Offer Contract

- Clients post jobs with budget, scope, and deadlines
- Cancel/edit if unclaimed
- Support private and public listings

### Proposal & Bidding Contract

- Freelancers submit offers and delivery timelines
- Clients accept one or multiple bids
- Transparent and timestamped submission history

### Escrow & Payment Contract

- Escrow system for client funds
- Auto-release funds upon job/milestone completion
- Refund and cancelation logic

### Milestone Contract

- Allows multi-part jobs
- Partial payments and iterative review
- Supports progress-based evaluations

### Review & Reputation Contract

- Immutable reviews by both parties
- Weighted trust scores
- Public and verifiable rating history

### Dispute Resolution Contract

- DAO-member jury voting mechanism
- Evidence submission and off-chain context hashes
- Resolution triggers payment/refund from escrow

### Certification Contract

- Register and issue skill certificates (e.g., Solidity, UI/UX)
- Validate credentials during hiring
- NFT-based proof of skill

### Incentives & Staking Contract

- Freelancers stake tokens to signal trust
- Rewards for high ratings and on-time delivery
- Slashing for missed deadlines or dispute losses

## Installation

1. Install [Clarinet](https://docs.stacks.co/docs/clarity/clarinet-cli)
2. Clone this repository:
   ```bash
   git clone https://github.com/your-org/tallyup.git
   cd tallyup
   ```
3. Run tests:
   ```bash
   npm test
   ```
4. Deploy contracts:
   ```bash
   Clarinet deploy
   ```

## Usage

- Each contract is modular and can be deployed independently. Start by deploying the Profile Registry and Job Offer contracts. Escrow, reviews, and dispute resolution can be added progressively depending on system scope.

> Refer to the individual .clar files and test cases for interface and usage details.

## Testing

Unit tests are written in Clarity using mock principals and sample job flows. Run:

``bash
npm test
``

## License

MIT License