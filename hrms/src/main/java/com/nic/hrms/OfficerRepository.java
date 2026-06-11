package com.nic.hrms;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OfficerRepository extends JpaRepository<Officer, Long> {
    // Spring Boot automatically provides findAll(), findById(), save(), etc.
}