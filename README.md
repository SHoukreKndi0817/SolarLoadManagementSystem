# Volta - Solar Load Management System

Volta is a comprehensive Solar Load Management System designed to optimize and monitor solar energy usage. It is a robust solution that integrates hardware and software to manage solar energy loads, ensuring efficient energy distribution and seamless control. The system is equipped with features for administrators, technical experts, and clients, providing a user-friendly interface and backend system for effective energy management.

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Technologies Used](#technologies-used)
4. [System Architecture](#system-architecture)
5. [Installation](#installation)
6. [Usage](#usage)
7. [API Endpoints](#api-endpoints)
8. [Contributing](#contributing)
9. [License](#license)

---

## Project Overview
Volta simplifies the management of solar energy by integrating advanced technologies for monitoring and controlling solar energy systems. It supports real-time data tracking, socket control, task scheduling, and detailed analytics for effective energy utilization. The platform is ideal for residential and commercial solar setups.

---

## Features

### For Clients:
- View real-time energy statistics (voltage, consumption, solar generation).
- Schedule tasks for home devices.
- Monitor device activity logs.
- Control sockets remotely (turn on/off).
- Receive system alerts and notifications.
- Manage personal account information.

### For Technical Experts:
- Add and manage client accounts.
- Configure and monitor solar system setups.
- Define and manage broadcast devices and sockets.
- Request and manage equipment for installations.
- View and analyze solar system performance.
- Provide support to clients.

### For Admins:
- Manage technical expert and client accounts.
- Approve or reject equipment requests.
- Oversee all solar systems and devices.
- Generate and manage QR codes for broadcast devices.
- Analyze system-wide energy performance.

---

## Technologies Used

### Backend:
- **Framework:** Laravel
- **Database:** MySQL
- **API Development:** RESTful APIs

### Frontend:
- **Client & Technical Expert Apps:** Flutter
- **Admin Dashboard:** HTML, CSS, JavaScript

### Other Tools:
- **Version Control:** Git & GitHub
- **Development Models:** Agile, Incremental

---

## System Architecture
The system leverages multiple architectural patterns:
1. **Client-Server Architecture**: Manages communication between frontend applications (Flutter & Admin Dashboard) and the backend (Laravel API).
2. **Event-Driven Architecture**: Handles real-time updates like system alerts and device state changes.
3. **Model-View-Controller (MVC)**: Organizes the backend and frontend for scalable and maintainable development.

---

## Installation

### Prerequisites:
- PHP >= 8.2
- Composer
- MySQL
- Node.js
- Git

### Steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/SHoukreKndi0817/SolarLoadManagementSystem.git
   ```
2. Navigate to the project directory:
   ```bash
   cd SolarLoadManagementSystem
   ```
3. Install dependencies:
   ```bash
   composer install
   npm install
   ```
4. Configure the `.env` file with your database and API credentials.
5. Run database migrations:
   ```bash
   php artisan migrate
   ```
6. Start the server:
   ```bash
   php artisan serve
   ```

---

## Usage

### Admin Dashboard:
1. Access via browser at `http://localhost:8000/admin`.
2. Use provided admin credentials to log in.

### Client & Technical Expert Apps:
1. Build and deploy the Flutter applications.
2. Use respective credentials to access their features.

### API Testing:
- Use tools like Postman or Insomnia to test API endpoints.
- Refer to the [API Endpoints](#api-endpoints) section for details.

---

## API Endpoints

### Authentication:
- **Login:**
  ```http
  POST /api/login
  ```
- **Logout:**
  ```http
  POST /api/logout
  ```

### Solar System Management:
- **Add Solar System:**
  ```http
  POST /api/solar-systems
  ```
- **Get Solar System Details:**
  ```http
  GET /api/solar-systems/{id}
  ```

### Socket Control:
- **Turn On Socket:**
  ```http
  POST /api/sockets/{id}/on
  ```
- **Turn Off Socket:**
  ```http
  POST /api/sockets/{id}/off
  ```

For a complete list of endpoints, refer to the [API Documentation](#).

---

## Contributing

We welcome contributions to improve Volta. Please follow these steps:
1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes and push to your fork.
4. Open a pull request.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

Thank you for using Volta. We hope it empowers you to manage solar energy efficiently!

