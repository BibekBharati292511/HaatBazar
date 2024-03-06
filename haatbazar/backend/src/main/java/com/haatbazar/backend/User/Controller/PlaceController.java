package com.haatbazar.backend.User.Controller;

import com.haatbazar.backend.User.Service.AddressService;
import org.asynchttpclient.AsyncHttpClient;
import org.asynchttpclient.DefaultAsyncHttpClient;
import org.asynchttpclient.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.Collections;
import java.util.concurrent.ExecutionException;

@RestController
public class PlaceController {
    @Autowired
    private AddressService addressService;

    @GetMapping("/address")
    public String getAddress(@RequestParam("lat") String latitude, @RequestParam("lon") String longitude) {
        return addressService.getAddress(latitude, longitude);
    }

    @GetMapping("/place/autocomplete")
    public ResponseEntity<Object> placeApiAutocomplete(@RequestParam String search_text) throws ExecutionException, InterruptedException, IOException {
        // Validate request parameters (if needed)
        if (search_text == null || search_text.isEmpty()) {
            // Handle validation errors
            return ResponseEntity.badRequest().body("search_text is required");
        }

        // Construct the URL with query parameters
        String apiUrl = "https://map-places.p.rapidapi.com/queryautocomplete/json";
        String rapidApiKey = "api key";
        String rapidApiHost = "map-places.p.rapidapi.com";
        String location = "Bharati";
        int radius = 50000;
        String language = "English";

        String url = apiUrl + "?input=" + search_text +
                "&radius=" + radius +
                "&language=" + language +
                "&location=" + location;

        // Make an asynchronous HTTP GET request using AsyncHttpClient
        AsyncHttpClient asyncHttpClient = new DefaultAsyncHttpClient();
        Response response = asyncHttpClient.prepareGet(url)
                .addHeader("X-RapidAPI-Key", rapidApiKey)
                .addHeader("X-RapidAPI-Host", rapidApiHost)
                .execute()
                .toCompletableFuture()
                .get(); // Wait for the response

        // Get the response body as a string
        String responseBody = response.getResponseBody();

        // Close the AsyncHttpClient
        asyncHttpClient.close();

        // Return the response from the API
        return ResponseEntity.ok(responseBody);
    }
    @GetMapping("/place/details")
    public ResponseEntity<Object> getPlaceDetails(@RequestParam String place_id) {
        String apiUrl = "https://map-places.p.rapidapi.com/details/json";
        String rapidApiKey = "1b09ca83e0msh4abf69ebd3368d8p11843djsn23b3cb67ff4e";
        String rapidApiHost = "map-places.p.rapidapi.com";

        String url = apiUrl + "?place_id=" + place_id;

        HttpHeaders headers = new HttpHeaders();
        headers.set("X-RapidAPI-Key", rapidApiKey);
        headers.set("X-RapidAPI-Host", rapidApiHost);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        HttpEntity<String> entity = new HttpEntity<>(headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);

        if (response.getStatusCode() == HttpStatus.OK) {
            return ResponseEntity.ok(response.getBody());
        } else {
            return ResponseEntity.status(response.getStatusCode()).body("Failed to fetch place details");
        }
    }
}
