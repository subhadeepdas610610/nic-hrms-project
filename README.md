# NIC HRMS - Visitor Slot Generation Module

A three-tier web application prototype built with Java Spring Boot, PostgreSQL, and an HTML5/CSS3 frontend interface.

## System Prerequisites

- Java 17 or 21 installed
- PostgreSQL database engine installed (default port 5432)

## How to Run Locally

### 1. Database Setup

1. Open pgAdmin and create a database named `hrms_visitor`.
2. Run the SQL script to create the `officer` table and insert dummy entries.
3. Update `src/main/resources/application.properties` with your local PostgreSQL password if it differs from `9696`.

### 2. Run the Spring Boot Backend

Navigate to the backend directory and start the server application:

```bash
cd hrms
./mvnw spring-boot:run

3. Launch Frontend Form
Open the root directory and double-click index.html to open the user interface form in any web browser.
```
