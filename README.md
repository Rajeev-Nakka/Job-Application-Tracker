# Recruiting / Applicant Tracker

A Salesforce-based application built to track personal job and internship applications (e.g. Stripe, Salesforce, Infosys) — replacing messy spreadsheet tracking with a structured, automated system.

## Problem

Job seekers applying to multiple companies simultaneously struggle to track which company they applied to, what stage each application is at, and when to follow up. Spreadsheets are easy to forget, give no reminders, and provide no real visibility into the overall pipeline.

## Solution

A Salesforce app that centralizes every application in one place, with:

- Automated follow-up reminders (Flow)
- A Kanban-style board for viewing applications by stage (Lightning Web Component)
- Business logic and data integrity enforced through Apex and validation rules
- A dashboard showing pipeline health at a glance

This project was built primarily as a hands-on way to learn and demonstrate practical Salesforce development skills (data modeling, declarative automation, Apex, LWC, and reporting), using a problem I genuinely have while job hunting. Polished tools like [Huntr](https://huntr.co) and [Teal](https://tealhq.com) already exist for this purpose — this project isn't trying to compete with them, but to show real, applied Salesforce skill end to end.

## Tech Stack / Tools

| Tool | Purpose |
|---|---|
| Salesforce Developer Edition | Free org used to build and run the app |
| Salesforce CLI (`sf`) | Deploying and retrieving metadata |
| VS Code + Salesforce Extension Pack | Primary development environment |
| Apex | Backend logic (trigger, service class, tests) |
| Lightning Web Components (LWC) | Custom Kanban board UI |
| Flow Builder | Declarative automation (follow-up date calculation) |
| Reports & Dashboards | Pipeline analytics |
| GitHub | Version control |

## Architecture Overview

**Data Model:** `Job_Application__c` custom object with fields:

| Field | Type | Purpose |
|---|---|---|
| Application Name | Text (auto) | Identifies each record |
| Role | Text | Job title applied for |
| Status | Picklist | Saved, Applied, Interviewing, Offer, Rejected |
| Applied Date | Date | When the application was submitted |
| Follow Up Date | Date | Auto-calculated: Applied Date + 7 days |
| Days Since Applied | Number | Auto-calculated by Apex trigger |
| Notes | Long Text Area | Free-form notes |
| Job Posting Link | URL | Link to the original posting |

**Automation:**
- A Record-Triggered Flow calculates `Follow_Up_Date__c` whenever `Applied_Date__c` is set
- A Validation Rule prevents `Follow_Up_Date__c` from being earlier than `Applied_Date__c`

**Apex:**
- `JobApplicationTrigger` — keeps `Days_Since_Applied__c` up to date on every save
- `JobApplicationService` — reusable logic to fetch all applications, fetch stale applications (Applied status, 14+ days old), and update an application's status
- `JobApplicationServiceTest` — Apex test coverage for the service class

**UI:**
- A custom Lightning App ("Job Tracker") with a Job Application tab
- A Lightning Web Component Kanban board showing applications grouped by status, with color-coded columns and empty-state messaging

**Reporting:**
- Reports and a dashboard ("Recruiting Pipeline Dashboard") showing pipeline by stage, outcomes split, applications by company, upcoming follow-ups, and stale applications

## Project Structure

```
force-app/main/default/
├── objects/Job_Application__c/     # Custom object and fields
├── flows/                          # Follow-up date automation
├── triggers/                       # JobApplicationTrigger
├── classes/                        # JobApplicationService + tests
├── lwc/                            # Kanban board component
├── reports/RecruitingTrackerReports/
└── dashboards/RecruitingTrackerReports/
```

## Build Phases

1. **Data Model & Environment Setup** — custom object, fields, GitHub, dedicated Developer org
2. **Declarative Automation** — Flow for follow-up dates, validation rule
3. **Apex** — trigger, service class, and test coverage
4. **Lightning Web Component** — Kanban board UI
5. **Reports & Dashboard** — pipeline analytics
6. **Polish & Documentation** — this README, repo cleanup, deploy story

## Setup / How to Run This Yourself

1. Clone this repo
2. Install the [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli)
3. Authorize a Salesforce org: `sf org login web --alias tracker-org --set-default`
4. Deploy the project: `sf project deploy start --source-dir force-app`
5. Open the org: `sf org open --target-org tracker-org`
6. Launch the **Job Tracker** app from the App Launcher


## Future Scope

- AI-assisted cover letter / follow-up email generation
- Job board API integration for auto-populating application details
- Multi-user version with proper sharing rules
- CI/CD pipeline via GitHub Actions + Salesforce CLI

## Author

Rajeev Nakka — IT/CSE undergraduate, built while actively applying to internships including Stripe and Salesforce.

## License

MIT License — see [LICENSE](LICENSE)
