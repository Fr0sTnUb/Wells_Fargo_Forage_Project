package com.wellsfargo.counselor.entity;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "advisor")
public class Advisor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long advisorId;

    @Column(nullable = false)
    private String firstName;

    @Column(nullable = false)
    private String lastName;

    @Column(nullable = false, unique = true)
    private String email;

    @Column
    private String phone;

    @Column
    private String address;

    // One Advisor can have many Clients
    @OneToMany(mappedBy = "advisor", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Client> clients;

    // Default constructor required by JPA
    public Advisor() {}

    public Advisor(String firstName, String lastName, String email, String phone, String address) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    // Getters and Setters

    public Long getAdvisorId() {
        return advisorId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public List<Client> getClients() {
        return clients;
    }

    public void setClients(List<Client> clients) {
        this.clients = clients;
    }
}
