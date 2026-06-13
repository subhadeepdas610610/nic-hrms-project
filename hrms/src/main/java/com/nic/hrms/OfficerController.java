package com.nic.hrms;

import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class OfficerController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/officers")
    public List<Map<String, Object>> getAllOfficers() {
        return jdbcTemplate.queryForList("SELECT id, name, office FROM officer ORDER BY id ASC");
    }

    @PostMapping("/generate-slots")
    public List<String> generateSlots(@RequestBody Map<String, Object> requestData) {
        String visitorName = (String) requestData.get("visitorName");
        int officerId = (int) requestData.get("officerId");
        String visitDate = (String) requestData.get("visitDate");
        String fromTimeStr = (String) requestData.get("timeFrom");
        String toTimeStr = (String) requestData.get("timeTo");
        int interval = (int) requestData.get("slotDuration");

        // 1. Insert transaction token directly into our pass_requests table
        String insertSQL = "INSERT INTO pass_requests (visitor_name, officer_id, visit_date, time_from, time_to, slot_duration, status) VALUES (?, ?, CAST(? AS DATE), CAST(? AS TIME), CAST(? AS TIME), ?, 'PENDING')";
        jdbcTemplate.update(insertSQL, visitorName, officerId, visitDate, fromTimeStr, toTimeStr, interval);

        // 2. Generate the computational sub-slots visual representation array
        List<String> slots = new ArrayList<>();
        try {
            LocalTime startTime = LocalTime.parse(fromTimeStr);
            LocalTime endTime = LocalTime.parse(toTimeStr);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a");

            while (startTime.isBefore(endTime)) {
                LocalTime slotEndTime = startTime.plusMinutes(interval);
                if (slotEndTime.isAfter(endTime))
                    break;
                slots.add(startTime.format(formatter) + " - " + slotEndTime.format(formatter));
                startTime = slotEndTime;
            }
        } catch (Exception e) {
            slots.add("Error calculation parser block active.");
        }
        return slots;
    }

    @GetMapping("/requests/officer/{officerId}")
    public List<Map<String, Object>> getOfficerRequests(@PathVariable int officerId) {
        String sql = "SELECT pass_id AS \"passId\", visitor_name AS \"visitorName\", visit_date AS \"visitDate\", time_from AS \"timeFrom\", time_to AS \"timeTo\", status FROM pass_requests WHERE officer_id = ? ORDER BY pass_id DESC";
        return jdbcTemplate.queryForList(sql, officerId);
    }

    @GetMapping("/requests/all")
    public List<Map<String, Object>> getAllRequests() {
        String sql = "SELECT pass_id AS \"passId\", visitor_name AS \"visitorName\", officer_id AS \"officerId\", time_from AS \"timeFrom\", status FROM pass_requests ORDER BY pass_id DESC";
        return jdbcTemplate.queryForList(sql);
    }

    @PutMapping("/requests/{passId}/status")
    public void updateStatus(@PathVariable int passId, @RequestParam String status) {
        jdbcTemplate.update("UPDATE pass_requests SET status = ? WHERE pass_id = ?", status, passId);
    }
}