# Wells Fargo Investment Management System

A Spring Boot backend for managing financial advisors, their clients, client portfolios, and portfolio securities. Built as part of the Wells Fargo Software Engineering Virtual Experience on Forage.

## Project Overview

This system helps financial advisors manage their customers' investment portfolios more efficiently. It uses the **Java Persistence API (JPA)** to map Java objects to a relational database, with **Spring Boot** as the application framework.

## Data Model

The system tracks four core entities:

```
FINANCIAL_ADVISOR  ──(1:N)──  CLIENT  ──(1:1)──  PORTFOLIO  ──(1:N)──  SECURITY
```

| Entity | Description |
|---|---|
| `Advisor` | A financial advisor who manages one or more clients |
| `Client` | A customer belonging to one advisor, with one portfolio |
| `Portfolio` | A collection of securities owned by a client |
| `Security` | An individual investment holding within a portfolio |

## Entity Relationships

- **Advisor → Client**: One advisor manages many clients (`@OneToMany`)
- **Client → Portfolio**: Each client has exactly one portfolio (`@OneToOne`)
- **Portfolio → Security**: A portfolio contains zero or more securities (`@OneToMany`)

## Tech Stack

- **Java** with Spring Boot
- **Java Persistence API (JPA)** — `javax.persistence`
- **Spring Data JPA** for ORM
- **Relational Database** (H2 for dev / PostgreSQL for production)

## Project Structure

```
src/
└── main/
    └── java/
        └── com/wellsfargo/counselor/
            └── entity/
                ├── Advisor.java
                ├── Client.java
                ├── Portfolio.java
                └── Security.java
```

## Getting Started

### Prerequisites

- Java 11+
- IntelliJ IDEA (recommended)
- Maven or Gradle

### Setup

1. **Fork and clone** the starter repository
2. Open the project in IntelliJ IDEA
3. Place the entity classes in `src/main/java/com/wellsfargo/counselor/entity/`
4. Run the application — Spring Boot will auto-create the database schema via JPA

```bash
./mvnw spring-boot:run
```

## Entity Implementation Notes

Each entity class follows these JPA conventions:

- Annotated with `@Entity` from `javax.persistence`
- Primary key auto-generated via `@GeneratedValue(strategy = GenerationType.IDENTITY)`
- No setter provided for the `id` field (auto-managed by JPA)
- All instance variables annotated with `@Column` or a relationship annotation
- A constructor that initializes all instance variables
- Getters and setters for every non-id field

## Security Fields

As required by the system spec, every `Security` record tracks:

- `name` — name of the security
- `category` — type/category of the security
- `purchaseDate` — date the security was purchased
- `purchasePrice` — price at time of purchase
- `quantity` — number of units held

## Author

Built as Task 1 & 2 of the **Wells Fargo Software Engineering Job Simulation** on [Forage](https://www.theforage.com).
