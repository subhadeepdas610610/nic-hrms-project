package com.nic.hrms;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class OfficerController {

    private final OfficerRepository officerRepository;

    public OfficerController(OfficerRepository officerRepository) {
        this.officerRepository = officerRepository;
    }

    @GetMapping("/officers")
    public List<Officer> getAllOfficers() {
        return officerRepository.findAll();
    }

    // NEW ENDPOINT: Mathematical slot generation logic
    @PostMapping("/generate-slots")
    public List<String> generateSlots(@RequestBody Map<String, String> requestData) {
        String fromTimeStr = requestData.get("fromTime"); // e.g. "10:00"
        String toTimeStr = requestData.get("toTime"); // e.g. "12:00"
        int interval = Integer.parseInt(requestData.get("interval")); // e.g. 30

        List<String> slots = new ArrayList<>();

        try {
            LocalTime startTime = LocalTime.parse(fromTimeStr);
            LocalTime endTime = LocalTime.parse(toTimeStr);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a");

            while (startTime.isBefore(endTime)) {
                LocalTime slotEndTime = startTime.plusMinutes(interval);
                if (slotEndTime.isAfter(endTime))
                    break;

                // Formats slot like "10:00 AM - 10:30 AM"
                slots.add(startTime.format(formatter) + " - " + slotEndTime.format(formatter));
                startTime = slotEndTime; // Move to next slot
            }
        } catch (Exception e) {
            slots.add("Error parsing times. Ensure 24-hour format inputs.");
        }

        return slots;
    }
}