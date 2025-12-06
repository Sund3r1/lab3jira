package com.example.demo;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class DemoApplicationTests {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void contextLoads() {
        // Простой тест для демонстрации
    }

    @Test
    public void homeEndpointShouldReturnWelcomeMessage() {
        String response = this.restTemplate.getForObject(
            "http://localhost:" + port + "/", 
            String.class
        );
        assertThat(response).contains("Hello from CI/CD Demo!");
    }

    @Test
    public void healthEndpointShouldReturnUp() {
        String response = this.restTemplate.getForObject(
            "http://localhost:" + port + "/health", 
            String.class
        );
        assertThat(response).contains("UP");
    }
}
