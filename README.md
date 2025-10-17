# 🧩 Flutter Testing Laboratory

🎯 **Project Overview**

This repository is a practical Flutter testing challenge designed to strengthen debugging, testing, and clean code practices.  
It includes **three broken widgets** — each with its own bugs and logic issues.  
Your mission was to **detect**, **fix**, and **test** them using professional Git workflow and Flutter testing techniques.

---

## 📦 Project Structure

### 🧱 1. User Registration Form
A user registration form with validation logic for email and password.

#### 🔍 Issues Fixed
- Invalid email formats were accepted (e.g., `"a@"`, `"@b"`).  
- No password strength validation.  
- Form could be submitted even when fields were empty or invalid.  
- No test coverage for validation logic or UI behavior.

#### 🛠 Fixes Implemented
✅ Added **regex-based email validation**  
✅ Implemented **strong password rules** (minimum length, numbers, symbols)  
✅ Prevented submission when form is invalid  
✅ Added **unit tests** for validation functions  
✅ Added **widget tests** for form behavior and error messages

---

### 🛒 2. Shopping Cart
A simple shopping cart logic module for adding, removing, and calculating totals.

#### 🔍 Issues Fixed
- Duplicate products were added separately instead of increasing quantity.  
- Discount calculation formula was incorrect.  
- Total price calculation didn’t account for discounts properly.  
- No tests existed for core functions or edge cases.

#### 🛠 Fixes Implemented
✅ Updated logic to **increase quantity** for existing items  
✅ Corrected **discount and total price** calculations  
✅ Added **unit tests** for:
  - `addItem`, `removeItem`, and `calculateTotal` functions  
  - Edge cases (empty cart, 100% discount, large quantities)  

---

### 🌦️ 3. Weather Display
A weather information widget that converts and displays temperature data.

#### 🔍 Issues Fixed
- Incorrect temperature conversion (missing `+32` for Fahrenheit).  
- App crashed when API returned `null` or incomplete data.  
- Loading state remained active after an error.  
- No tests for conversion logic or UI state handling.

#### 🛠 Fixes Implemented
✅ Corrected **Celsius ↔ Fahrenheit** conversion formula  
✅ Added **null safety** and proper error handling  
✅ Fixed **state management** for `Loading`, `Success`, and `Error` states  
✅ Added **unit tests** for temperature conversion and data parsing  
✅ Added **widget tests** for UI behavior and state display

---

## 🧪 Testing Overview

### 🧩 Types of Tests Implemented
- **Unit Tests** → Core business logic, validation, and calculations  
- **Widget Tests** → Form interaction, error messages, and state rendering  
- **Edge Case Tests** → Empty inputs, invalid states, and special discount scenarios  

### 🧰 Example Commands
Run all tests:
```bash
flutter test
