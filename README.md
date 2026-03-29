# Tapella

## Overview  
Tapella is a platform that connects service providers/businesses with users who are looking for services. For example, a plumber, electrician, or salon owner can list their services, while users can browse, request, and manage service bookings.

The project demonstrates authentication, authorization, CRUD operations, layered architecture, and integration with a local REST API.

---

## Features  

### User Roles  

Service Provider (Business)
- Create, view, update, and delete service listings  
- Manage incoming service requests  
- View and update their service offerings  

Customer (User)
- Browse available services  
- Send service requests  
- View and manage their requests  
- Leave reviews and ratings  

---

### Authentication & Authorization  
- User registration and login  
- Role-based access control (Service Provider / Customer)  
- Users can only access features allowed for their role  

---

## Business Features (CRUD)  

### 1. Service Listings Management (Service Providers)
- Create service listings  
- View their services  
- Update service details  
- Delete services  


### 2. Reviews & Ratings Management  
- Customers can create reviews and ratings for services  
- Users can view reviews  
- Users can update their own reviews  
- Users can delete their own reviews  

---

## Additional Features (Fully CRUD – Non-Business Core)  

### 1. User Management (Admin/System Level)
- Create users (registration)  
- View user profiles  
- Update user information  
- Delete user accounts  

### 2. Profile Management  
- Create and edit user profiles  
- View profile details  
- Update personal information  
- Delete or deactivate profiles  

---

## Architecture  

The project follows a layered architecture:

### Presentation Layer  
- Flutter UI  
- Handles user interaction and navigation  

### Business Layer  
- Contains application logic  
- Handles validation and rules  
- Mediates between UI and data layer  

### Data Layer  
- Repository: Provides abstraction over data sources  
- Data Provider: Communicates with the REST API  
- Handles all CRUD operations  

---

## Backend  
- Local REST API  
- Handles authentication, authorization, and CRUD operations  
- Runs on the developer’s machine  

---

## Project Members  

| Full Name          | ID (UGR/XXXX/YY) |
| ------------------ | ---------------- |
| Kaleab Mulugeta    | UGR/7783/16      |
| Efrata Endalkachew | UGR/2103/16      |
| Saron Kiflu        | UGR/9821/16      |
| Naomi Mesfin       | UGR/8207/16      |
| Elroi Tesfaye      | UGR/1293/16      |
