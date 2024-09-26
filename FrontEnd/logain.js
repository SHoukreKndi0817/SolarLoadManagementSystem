// Function to validate username
function validateSignInUsername() {
    const usernameInput = document.getElementById('sign-in-username');
    const usernameError = document.getElementById('sign-in-username-error');
    
    if (usernameInput.value.trim() === '') {
        usernameError.textContent = 'Username is required!';
    } else {
        usernameError.textContent = '';
    }
}

// Function to validate password
function validateSignInPassword() {
    const passwordInput = document.getElementById('sign-in-password');
    const passwordError = document.getElementById('sign-in-password-error');

    if (passwordInput.value.trim() === '') {
        passwordError.textContent = 'Password is required!';
    } else {
        passwordError.textContent = '';
    }
}

// Handle sign-in button click
document.getElementById('sign-in-btn').addEventListener('click', function(e) {
    e.preventDefault();

    const user_name = document.getElementById('sign-in-username').value.trim();
    const password = document.getElementById('sign-in-password').value.trim();

    // Validate empty fields
    if (!user_name || !password) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'All fields are required!'
        });
        return;
    }

    // Validate password length
    if (password.length < 6) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Password must be at least 6 characters long!'
        });
        return;
    }

    // Call the API to check login
    fetch(`https://volta.sy/api/Dash/Login?user_name=${encodeURIComponent(user_name)}&password=${encodeURIComponent(password)}`, {
        method: 'POST'
    })
    .then(response => {
        if (!response.ok) {
            return response.json().then(data => {
                throw new Error(data.msg || 'An unexpected error occurred');
            });
        }
        return response.json();
    })
    .then(data => {
        // Handle different API responses
        switch(data.msg) {
            case "Login successfully":
                const token = data['super_admin date']?.token;
                if (token) {
                    sessionStorage.setItem('token', token); // Store token
                }
                Swal.fire({
                    position: "top-end",
                    icon: "success",
                    title: `Welcome ${user_name}`,
                    showConfirmButton: false,
                    timer: 1500
                }).then(() => {
                    window.history.replaceState(null, null, 'Admin.html');
                    window.location.href = 'loading.html'; 
                });
                break;
            case "Login failed: Invalid credentials":
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Invalid username or password. Please try again!'
                });
                break;
            case "Your account has been deactivated by the company":
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Your account has been deactivated by the company!'
                });
                break;
            default:
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'An unexpected error occurred. Please try again later!'
                });
                break;
        }
    })
    .catch(error => {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: error.message || 'An error occurred while connecting to the API! Please try again later.'
        });
    });
});
