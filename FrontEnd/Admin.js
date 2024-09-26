let experts = [];
let nextId = 1;
let nextDeviceId = 1;
let devices = [];
async function fetchExperts() {
    const token = sessionStorage.getItem('token');
    console.log("Token:", token); 
    if (!token) {
        console.error('Token is missing');
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Token is missing. Please log in again.'
        });
        return;
    }

    try {
        const response = await fetch('https://volta.sy/api/Dash/ShowAllTechnicalExpert', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch experts');
        }

        const data = await response.json();

        if (data['All Technical Expert'] && data['All Technical Expert'].length > 0) {
            experts = data['All Technical Expert'].map(expert => ({
                id: expert.technical_expert_id,
                name: expert.name,
                phone_number: expert.phone_number,
                home_address: expert.home_address,
                user_name: expert.user_name,
                admin_id: expert.admin_id,
                role: expert.role,
                created_at: new Date(expert.created_at).toLocaleString(`en-GB`), // Format created_at
                updated_at: new Date(expert.updated_at).toLocaleString(`en-GB`), // Format updated_at
                is_active: expert.is_active // Include is_active status
            }));
        } else {
            experts = [];
        }

        updateExpertTable();
    } catch (error) {
        console.error('Error fetching experts:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to fetch experts'
        });
    }
}




function updateExpertTable(searchTerm = '') {
    const tableBody = document.querySelector('#expertTable tbody');
    tableBody.innerHTML = '';

    const filteredExperts = experts.filter(expert => 
        expert.name.toLowerCase().includes(searchTerm.toLowerCase())
    );

    filteredExperts.forEach(expert => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${expert.name}</td>
            <td>${expert.phone_number}</td>
            <td>${expert.home_address}</td>
            <td>${expert.user_name}</td>
            <td>${expert.created_at || 'N/A'}</td>
            <td>${expert.updated_at || 'N/A'}</td>
            <td>${expert.is_active ? 'Active' : 'Inactive'}</td> <!-- New column for status -->
            <td>
                <button style="width:100px;background-color: #468c9b;" class="btn-edit" onclick="editExpert(${expert.id})">Edit</button>
                <button class="btn-toggle ${expert.is_active ? 'deactivate' : 'activate'}" onclick="toggleExpert(${expert.id}, ${expert.is_active})">
                    ${expert.is_active ? 'Deactivate' : 'Activate'}
                </button>
            </td>
        `;
        tableBody.insertBefore(row, tableBody.firstChild); // Ensure new experts are added at the top
    });
}

async function toggleExpert(id, isActive) {
    const token = sessionStorage.getItem('token');
    if (!token) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Token is missing. Please log in again.'
        });
        return;
    }

    try {
        const url = isActive 
            ? `https://volta.sy/api/Dash/DeactivateTechnicalExpert?technical_expert_id=${id}`
            : `https://volta.sy/api/Dash/ActivateTechnicalExpert?technical_expert_id=${id}`;

        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });

        const data = await response.json();

        if (response.ok) {
            Swal.fire({
                position: "top-end",
                icon: "success",
                title: `Technical Expert account has been ${isActive ? 'deactivated' : 'activated'} successfully`,
                showConfirmButton: false,
                timer: 1500
            });
            // Update expert list
            fetchExperts();
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: data.msg || `Failed to ${isActive ? 'deactivate' : 'activate'} expert`
            });
        }
    } catch (error) {
        console.error('Error toggling expert status:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to update expert status'
        });
    }
}

async function addExpert() {
    try {
        const formHtml = `
            <style>
                #expertForm {
                    display: flex;
                    flex-direction: column;
                    gap: 15px;
                }
                #expertForm input {
                    padding: 10px;
                    border-radius: 5px;
                    border: 1px solid #ddd;
                    font-size: 1em;
                }
                #expertForm .admin-id {
                    display: none; /* Hide the admin_id field */
                }
            </style>
            <form id="expertForm">
                <input id="name" placeholder="Name" type="text" required />
                <input id="phone_number" placeholder="Phone Number" type="text" required />
                <input id="home_address" placeholder="Home Address" type="text" required />
                <input id="user_name" placeholder="Username" type="text" required />
                <input id="password" placeholder="Password" type="password" required />
                <input id="admin_id" class="admin-id" value="1" readonly />
            </form>
        `;

        const result = await Swal.fire({
            title: "Enter expert's details",
            html: formHtml,
            showCancelButton: true,
            confirmButtonText: "Add Expert",
            preConfirm: () => {
                const form = document.getElementById('expertForm');
                const name = form.elements.name.value.trim();
                const phone_number = form.elements.phone_number.value.trim();
                const home_address = form.elements.home_address.value.trim();
                const user_name = form.elements.user_name.value.trim();
                const password = form.elements.password.value.trim();
                const admin_id = form.elements.admin_id.value.trim();

                // Validation
                if (!name || !phone_number || !home_address || !user_name || !password) {
                    Swal.showValidationMessage("All fields are required.");
                    return false;
                }

                if (name.length < 3) {
                    Swal.showValidationMessage("Name must be at least 3 characters.");
                    return false;
                }

                if (/[\d]/.test(name)) {
                    Swal.showValidationMessage("Name must not contain numbers.");
                    return false;
                }

                if (user_name.length < 4) {
                    Swal.showValidationMessage("Username must be at least 4 characters.");
                    return false;
                }

                if (!/^\d{10,15}$/.test(phone_number)) {
                    Swal.showValidationMessage("Phone number must be 10 to 15 digits.");
                    return false;
                }

                if (password.length < 6) {
                    Swal.showValidationMessage("Password must be at least 6 characters.");
                    return false;
                }

                if (admin_id !== '1') {
                    Swal.showValidationMessage("Admin ID must be 1.");
                    return false;
                }

                return { name, phone_number, home_address, user_name, password, admin_id };
            }
        });

        if (result.isConfirmed) {
            const { name, phone_number, home_address, user_name, password, admin_id } = result.value;
            const token = sessionStorage.getItem('token');

            if (!token) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Token is missing. Please log in again.'
                });
                return;
            }

            try {
                const response = await fetch('https://volta.sy/api/Dash/AddTechnicalExpert', {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ name, phone_number, home_address, user_name, password, admin_id })
                });

                const data = await response.json();

                if (response.ok) {
                    Swal.fire({
                        position: "top-end",
                        icon: "success",
                        title: `Expert added successfully`,
                        showConfirmButton: false,
                        timer: 1500
                    });
                    // Optionally, fetch the updated list of experts
                    fetchExperts();
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: data.msg || 'Failed to add expert'
                    });
                }
            } catch (error) {
                console.error('Error adding expert:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to add expert'
                });
            }
        }
    } catch (error) {
        console.error('Error adding expert:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to add expert'
        });
    }
}
async function editExpert(id) {
    const expert = experts.find(expert => expert.id === id);
    if (!expert) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Expert not found'
        });
        return;
    }

    try {
        const formHtml = `
            <style>
                #editExpertForm {
                    display: flex;
                    flex-direction: column;
                    gap: 15px;
                }
                #editExpertForm input {
                    padding: 10px;
                    border-radius: 5px;
                    border: 1px solid #ddd;
                    font-size: 1em;
                }
            </style>
            <form id="editExpertForm">
                <input id="name" placeholder="Name" type="text" value="${expert.name}" />
                <input id="phone_number" placeholder="Phone Number" type="text" value="${expert.phone_number}" />
                <input id="home_address" placeholder="Home Address" type="text" value="${expert.home_address}" />
                <input id="technical_expert_id" type="hidden" value="${expert.id}" />
            </form>
        `;

        const result = await Swal.fire({
            title: "Edit expert's details",
            html: formHtml,
            showCancelButton: true,
            confirmButtonText: "Update Expert",
            preConfirm: () => {
                const form = document.getElementById('editExpertForm');
                const name = form.elements.name.value.trim();
                const phone_number = form.elements.phone_number.value.trim();
                const home_address = form.elements.home_address.value.trim();
                const technical_expert_id = form.elements.technical_expert_id.value.trim();

                // Validation
                if (!name || !phone_number || !home_address) {
                    Swal.showValidationMessage("All fields are required.");
                    return false;
                }

                if (name.length < 3) {
                    Swal.showValidationMessage("Name must be at least 3 characters.");
                    return false;
                }

                if (/[\d]/.test(name)) {
                    Swal.showValidationMessage("Name must not contain numbers.");
                    return false;
                }

                if (!/^\d{10,15}$/.test(phone_number)) {
                    Swal.showValidationMessage("Phone number must be 10 to 15 digits.");
                    return false;
                }

                return { name, phone_number, home_address, technical_expert_id };
            }
        });

        if (result.isConfirmed) {
            const { name, phone_number, home_address, technical_expert_id } = result.value;
            const token = sessionStorage.getItem('token');

            if (!token) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Token is missing. Please log in again.'
                });
                return;
            }

            try {
                const response = await fetch('https://volta.sy/api/Dash/EditTechnicalExpert', {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ name, phone_number, home_address, technical_expert_id })
                });

                const data = await response.json();

                if (response.ok) {
                    Swal.fire({
                        position: "top-end",
                        icon: "success",
                        title: `Expert updated successfully`,
                        showConfirmButton: false,
                        timer: 1500
                    });
                    // Optionally, fetch the updated list of experts
                    fetchExperts();
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: data.msg || 'Failed to update expert'
                    });
                }
            } catch (error) {
                console.error('Error updating expert:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to update expert'
                });
            }
        }
    } catch (error) {
        console.error('Error editing expert:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to edit expert'
        });
    }
}
function updateExpertTable(searchTerm = '') {
    const tableBody = document.querySelector('#expertTable tbody');
    tableBody.innerHTML = '';

    const filteredExperts = experts.filter(expert => 
        expert.name.toLowerCase().includes(searchTerm.toLowerCase())
    );

    filteredExperts.forEach(expert => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${expert.name}</td>
            <td>${expert.phone_number}</td>
            <td>${expert.home_address}</td>
            <td>${expert.user_name}</td>
            <td>${expert.created_at || 'N/A'}</td>
            <td>${expert.updated_at || 'N/A'}</td>
            <td>
                <button style="width:100px;background-color: #468c9b;" class="btn-edit" onclick="editExpert(${expert.id})">Edit</button>
                <button class="btn-toggle ${expert.is_active ? 'deactivate' : 'activate'}" onclick="toggleExpert(${expert.id}, ${expert.is_active})">
                    ${expert.is_active ? 'Deactivate' : 'Activate'}
                </button>
            </td>
        `;
        tableBody.insertBefore(row, tableBody.firstChild); // Ensure new experts are added at the top
    });
}

function showAndHide(showId, hideId) {
    document.getElementById(showId).style.display = 'block';
    document.getElementById(hideId).style.display = 'none';
}

document.getElementById('Add_expert').addEventListener('click', function() {
    showAndHide('showandhide', 'showandhide_table_device');
});

fetchExperts();



function showAndHide(showId, hideId) {
    document.getElementById(showId).style.display = 'block';
    document.getElementById(hideId).style.display = 'none';
}

document.getElementById('Add_expert').addEventListener('click', function() {
    showAndHide('showandhide', 'showandhide_table_device');
});

fetchExperts();

document.getElementById('chart').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'none';
    document.getElementById('showandhide_table_device').style.display = 'none';
    document.getElementById('showandhide_table_Admin').style.display = 'none';
    document.getElementById('showandhide_table_client').style.display = 'none';
    document.getElementById('showandhide_table_Pannel').style.display = 'none';
    document.getElementById('hideEquipment').style.display = 'none';
    document.getElementById('hideBroadcast_Device').style.display = 'none';
    document.getElementById('hide-Chart').style.display = 'block';
    document.getElementById('showandhide_table_inveter').style.display = 'none';


});
document.getElementById('Add_expert').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'block';
    document.getElementById('showandhide_table_device').style.display = 'none';
    document.getElementById('showandhide_table_Admin').style.display = 'none';
    document.getElementById('showandhide_table_client').style.display = 'none';
    document.getElementById('showandhide_table_Pannel').style.display = 'none';
    document.getElementById('hideEquipment').style.display = 'none';
    document.getElementById('hideBroadcast_Device').style.display = 'none';
    document.getElementById('hide-Chart').style.display = 'none';
    document.getElementById('showandhide_table_inveter').style.display = 'none';

});

document.getElementById('Battery').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'none';
    document.getElementById('showandhide_table_device').style.display = 'block';
    document.getElementById('showandhide_table_Admin').style.display = 'none';
    document.getElementById('showandhide_table_client').style.display = 'none';
    document.getElementById('showandhide_table_Pannel').style.display = 'none';
    document.getElementById('showandhide_table_inveter').style.display = 'none';
    document.getElementById('hideEquipment').style.display = 'none';
    document.getElementById('hideBroadcast_Device').style.display = 'none';
    document.getElementById('hide-Chart').style.display = 'none';


});

document.getElementById('User').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'none';
    document.getElementById('showandhide_table_device').style.display = 'none';
    document.getElementById('showandhide_table_Admin').style.display = 'block';
    document.getElementById('showandhide_table_client').style.display = 'none';
    document.getElementById('showandhide_table_Pannel').style.display = 'none';
    document.getElementById('hidepannel').style.display = 'none';
    document.getElementById('showandhide_table_inveter').style.display = 'none';
    document.getElementById('hideEquipment').style.display = 'none';
    document.getElementById('hideBroadcast_Device').style.display = 'none';
    document.getElementById('hide-Chart').style.display = 'none';

});
document.getElementById('Client').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'none';
    document.getElementById('showandhide_table_device').style.display = 'none';
    document.getElementById('showandhide_table_Admin').style.display = 'none';
    document.getElementById('showandhide_table_client').style.display = 'block';
    document.getElementById('showandhide_table_Pannel').style.display = 'none';
    document.getElementById('hidepannel').style.display = 'none';
    document.getElementById('showandhide_table_inveter').style.display = 'none';
    document.getElementById('hideEquipment').style.display = 'none';
    document.getElementById('hideBroadcast_Device').style.display = 'none';
    document.getElementById('hide-Chart').style.display = 'none';

});
document.getElementById('panel').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'none';
    document.getElementById('showandhide_table_device').style.display = 'none';
    document.getElementById('showandhide_table_Admin').style.display = 'none';
    document.getElementById('showandhide_table_client').style.display = 'none';
    document.getElementById('showandhide_table_Pannel').style.display = 'block';
    document.getElementById('hidepannel').style.display = 'block';
    document.getElementById('showandhide_table_inveter').style.display = 'none';
    document.getElementById('hideEquipment').style.display = 'none';
    document.getElementById('hideBroadcast_Device').style.display = 'none';

});
document.getElementById('Inverter').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'none';
    document.getElementById('showandhide_table_device').style.display = 'none';
    document.getElementById('showandhide_table_Admin').style.display = 'none';
    document.getElementById('showandhide_table_client').style.display = 'none';
    document.getElementById('showandhide_table_Pannel').style.display = 'none';
    document.getElementById('hidepannel').style.display = 'none';
    document.getElementById('showandhide_table_inveter').style.display = 'block';
    document.getElementById('hideEquipment').style.display = 'none';
    document.getElementById('hideBroadcast_Device').style.display = 'none';
    document.getElementById('hide-Chart').style.display = 'none';


});
document.getElementById('Equipment').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'none';
    document.getElementById('showandhide_table_device').style.display = 'none';
    document.getElementById('showandhide_table_Admin').style.display = 'none';
    document.getElementById('showandhide_table_client').style.display = 'none';
    document.getElementById('showandhide_table_Pannel').style.display = 'none';
    document.getElementById('hidepannel').style.display = 'none';
    document.getElementById('showandhide_table_inveter').style.display = 'none';
    document.getElementById('hideEquipment').style.display = 'block';
    document.getElementById('hideBroadcast_Device').style.display = 'none';
    document.getElementById('hide-Chart').style.display = 'none';

});
document.getElementById('Setting').addEventListener('click', function(e) {
    e.preventDefault();
    document.getElementById('showandhide').style.display = 'none';
    document.getElementById('showandhide_table_device').style.display = 'none';
    document.getElementById('showandhide_table_Admin').style.display = 'none';
    document.getElementById('showandhide_table_client').style.display = 'none';
    document.getElementById('showandhide_table_Pannel').style.display = 'none';
    document.getElementById('hidepannel').style.display = 'none';
    document.getElementById('showandhide_table_inveter').style.display = 'none';
    document.getElementById('hideEquipment').style.display = 'none';
    document.getElementById('hideBroadcast_Device').style.display = 'block';
    document.getElementById('hide-Chart').style.display = 'none';

});

// const menuItems = ['User', 'Client', 'panel', 'Inverter', 'Equipment', 'Setting'];
// menuItems.forEach(item => {
//     document.getElementById(item).addEventListener('click', function(e) {
//         e.preventDefault();
//         document.getElementById('showandhide').style.display = 'none';
//         document.getElementById('showandhide_table_device').style.display = 'none';
//     });
// });

document.getElementById('logout').addEventListener('click', async function () {
    const token = sessionStorage.getItem('token'); // Retrieve token from sessionStorage

    if (!token) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Token is missing. Please log in again.'
        });
        return;
    }

    try {
        const requestOptions = {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            redirect: 'follow'
        };

        const response = await fetch('https://volta.sy/api/logout', requestOptions);

        if (!response.ok) {
            throw new Error('Logout failed');
        }

        const data = await response.json();
        if (data.msg === 'success logout') {
            Swal.fire({
                position: "top-end",
                icon: "success",
                title: "Logged out successfully",
                showConfirmButton: false,
                timer: 1500
            });

            // Clear sessionStorage and redirect to login page
            sessionStorage.clear();
            window.location.href = "logain.html";
        } else {
            throw new Error(data.msg || 'Unexpected response');
        }
    } catch (error) {
        console.error('Error:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: error.message || 'Logout failed'
        });
    }
});

let sidebar = document.querySelector(".sidebar"); 
let closeBtn = document.querySelector("#btn"); 
let searchBtn = document.querySelector(".bx-search"); 
let content = document.querySelector(".main-content"); 

closeBtn.addEventListener("click", () => {
    sidebar.classList.toggle("open");
    content.style.marginLeft = sidebar.classList.contains("open") ? "200px" : "0px";
    menuBtnChange(); // Calling the function (optional)
});

searchBtn.addEventListener("click", () => {
    sidebar.classList.toggle("open");
    menuBtnChange(); // Calling the function (optional)
});

// Function to change sidebar button (optional)
function menuBtnChange() {
    if (sidebar.classList.contains("open")) {
        closeBtn.classList.replace("bx-menu", "bx-menu-alt-right");
    } else {
        closeBtn.classList.replace("bx-menu-alt-right", "bx-menu");
    }
}

document.addEventListener('DOMContentLoaded', function() {
    loadAdminData(); // Load admin data when the page is loaded
});

function populateAdminTable(admins) {
    const tableBody = document.querySelector('#adminTable tbody');
    tableBody.innerHTML = ''; // Clear existing rows

    admins.forEach(admin => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${admin.name}</td>
            <td>${admin.phone_number}</td>
            <td>${admin.user_name}</td>
            <td>${admin.role}</td>
            <td>${admin.is_active ? 'Active' : 'Inactive'}</td>
            <td>${new Date(admin.created_at).toLocaleDateString()}</td>
            <td>${new Date(admin.updated_at).toLocaleDateString()}</td>
            <td>
                <button style="background-color:#468c9b; width:100px" onclick="editAdmin(${admin.admin_id}, '${admin.name}', '${admin.phone_number}', '${admin.user_name}', '${admin.role}')">
                    Edit
                </button>
                <button class="btn-toggle ${admin.is_active ? 'deactivate' : 'activate'}" onclick="toggleAdmin(${admin.admin_id}, '${admin.is_active ? '1' : '0'}')">
                    ${admin.is_active ? 'Deactivate' : 'Activate'}
                </button>
            </td>
        `;
        tableBody.appendChild(row);
    });
}

function editAdmin(id, name, phoneNumber, userName, role) {
    Swal.fire({
        title: 'Edit Admin Data',
        html: `
          <style>
            .swal2-input, .swal2-select {
                display: block;
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #dcdcdc;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 16px;
            }
            .swal2-select {
                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
                background: url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAiIGhlaWdodD0iMTAwIj4KICA8ZyBzdHJva2U9IiMzMzMiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjY2xhc3M9ImNvbG9yIiBmaWxsPSJub25lIj4KICAgIDxwYXRoIGQ9Ik0xNTAsNTB2LTFoLTF2MWwtNTAsNTAtNTAsNTAtNTAsNSIgLz4KICA8L2c+Cjwvc3ZnPg==" ) no-repeat right center;
                background-size: 16px;
            }
          </style>
          <input id="name" class="swal2-input" placeholder="Name" value="${name}">
          <input id="phone_number" class="swal2-input" placeholder="Phone Number" value="${phoneNumber}">
          <input id="user_name" class="swal2-input" placeholder="Username" value="${userName}">
          <select id="role" class="swal2-select">
              <option value="super_admin" ${role === 'super_admin' ? 'selected' : ''}>Super Admin</option>
              <option value="employe" ${role === 'employe' ? 'selected' : ''}>Employe</option>
          </select>
        `,
        focusConfirm: false,
        preConfirm: () => {
            const name = Swal.getPopup().querySelector('#name').value.trim();
            const phoneNumber = Swal.getPopup().querySelector('#phone_number').value.trim();
            const userName = Swal.getPopup().querySelector('#user_name').value.trim();
            const role = Swal.getPopup().querySelector('#role').value;

            if (!name || !phoneNumber || !userName || !role) {
                Swal.showValidationMessage('All fields are required!');
                return false;
            }

            // Validation for name (at least 3 characters, no numbers)
            if (name.length < 3 || /\d/.test(name)) {
                Swal.showValidationMessage('Name must be at least 3 characters long and cannot contain numbers');
                return false;
            }

            // Validation for phone number (10 to 15 digits)
            if (!/^\d{10,15}$/.test(phoneNumber)) {
                Swal.showValidationMessage('Phone number must be between 10 and 15 digits');
                return false;
            }

            // Validation for user name (at least 4 characters)
            if (userName.length < 4) {
                Swal.showValidationMessage('Username must be at least 4 characters long');
                return false;
            }

            return { id, name, phoneNumber, userName, role };
        }
    }).then((result) => {
        if (result.isConfirmed) {
            const { id, name, phoneNumber, userName, role } = result.value;

            // Prepare the data to be sent to the API
            const requestData = {
                admin_id: id,
                name: name,
                phone_number: phoneNumber,
                user_name: userName,
                role: role
            };

            // Send the data to the API
            fetch('https://volta.sy/api/Dash/EditAdminData', {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${sessionStorage.getItem('token')}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(requestData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.msg === 'Successfully Edit') {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: 'Admin data has been updated.',
                        timer: 1500,
                        showConfirmButton: false
                    });
                    loadAdminData(); // Reload the table data
                } else {
                    Swal.fire('Error!', 'There was a problem updating the admin data.', 'error');
                }
            })
            .catch(error => {
                Swal.fire('Error!', 'An error occurred while updating the admin data.', 'error');
                console.error('Error:', error);
            });
        }
    });
}

async function toggleAdmin(id, currentStatus) {
    if (!id) {
        Swal.fire('Error!', 'Invalid admin ID.', 'error');
        return;
    }

    const token = sessionStorage.getItem('token');
    if (!token) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Token is missing. Please log in again.'
        });
        return;
    }

    try {
        const apiUrl = currentStatus === '1' 
            ? `https://volta.sy/api/Dash/DeactivateAdmin?admin_id=${id}` 
            : `https://volta.sy/api/Dash/ActivateAdmin?admin_id=${id}`;

        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });

        const data = await response.json();

        if (response.ok) {
            Swal.fire({
                position: 'top-end',
                icon: 'success',
                title: currentStatus === '1' ? 'Admin deactivated!' : 'Admin activated!',
                showConfirmButton: false,
                timer: 1500
            });
            // Refresh the admin list
            setTimeout(() => {
                loadAdminData(); // Reload the table data
            }, 1500);
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: data.msg || 'Failed to toggle admin status'
            });
        }
    } catch (error) {
        console.error('Error toggling admin status:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'An error occurred while toggling admin status.'
        });
    }
}

async function loadAdminData() {
    const token = sessionStorage.getItem('token');
    if (!token) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Token is missing. Please log in again.'
        });
        return;
    }

    try {
        const response = await fetch('https://volta.sy/api/Dash/ShowAllAdmin', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });

        const data = await response.json();

        if (data.msg === 'Successfully ') {
            populateAdminTable(data['All Admin']);
        } else {
            Swal.fire('Error!', 'Failed to load admin data.', 'error');
        }
    } catch (error) {
        console.error('Error loading admin data:', error);
        Swal.fire('Error!', 'An error occurred while loading admin data.', 'error');
    }
}


document.addEventListener('DOMContentLoaded', loadAdminData);

function addAdmin() {
    Swal.fire({
        title: 'Add Admin',
        html:
            '<style>' +
            '.swal2-input, .swal2-select {' +
            '  display: block;' +
            '  width: 100%;' +
            '  padding: 10px;' +
            '  margin: 10px 0;' +
            '  border: 1px solid #dcdcdc;' +
            '  border-radius: 4px;' +
            '  box-sizing: border-box;' +
            '}' +
            '.swal2-select {' +
            '  appearance: none;' +
            '  -webkit-appearance: none;' +
            '  -moz-appearance: none;' +
            '}' +
            '</style>' +
            '<input id="swal-input1" class="swal2-input" placeholder="Name">' +
            '<input id="swal-input2" class="swal2-input" placeholder="Phone Number">' +
            '<input id="swal-input3" class="swal2-input" placeholder="Username">' +
            '<input id="swal-input4" class="swal2-input" placeholder="Password" type="password">' +
            '<select id="swal-input5" class="swal2-select">' +
                '<option value="">Select Role</option>' +
                '<option value="super_admin">Super Admin</option>' +
                '<option value="employe">Employe</option>' +
            '</select>',
        focusConfirm: false,
        preConfirm: () => {
            const name = document.getElementById('swal-input1').value;
            const phone_number = document.getElementById('swal-input2').value;
            const user_name = document.getElementById('swal-input3').value;
            const password = document.getElementById('swal-input4').value;
            const role = document.getElementById('swal-input5').value;

            if (!name || !phone_number || !user_name || !password || !role) {
                Swal.showValidationMessage('All fields are required');
                return false;
            }

            // Validation for name (at least 3 characters, no numbers)
            if (name.length < 3 || /\d/.test(name)) {
                Swal.showValidationMessage('Name must be at least 3 characters long and cannot contain numbers');
                return false;
            }

            // Validation for phone number (10 to 15 digits)
            if (!/^\d{10,15}$/.test(phone_number)) {
                Swal.showValidationMessage('Phone number must be between 10 and 15 digits');
                return false;
            }

            // Validation for user name (at least 4 characters)
            if (user_name.length < 4) {
                Swal.showValidationMessage('Username must be at least 4 characters long');
                return false;
            }

            // Validation for password (at least 6 characters)
            if (password.length < 6) {
                Swal.showValidationMessage('Password must be at least 6 characters long');
                return false;
            }

            return { name, phone_number, user_name, password, role };
        }
    }).then((result) => {
        if (result.isConfirmed) {
            const token = sessionStorage.getItem('token');  // Assuming token is stored in sessionStorage
            const adminData = result.value;

            fetch("https://volta.sy/api/Dash/AddAdmin", {
                method: 'POST',
                headers: {
                    'Authorization': 'Bearer ' + token,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(adminData)
            })
            .then(response => {
                if (response.status === 422) {
                    return response.json().then(data => {
                        Swal.fire({
                            icon: 'error',
                            title: 'Validation Error',
                            text: data.msg || 'Invalid input data',
                        });
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data && data.msg === "Admin created successfully") {
                    Swal.fire({
                        position: "top-end",
                        icon: "success",
                        title: "Admin created successfully",
                        showConfirmButton: false,
                        timer: 1500
                    });

                    // Update the admin table instantly
                    updateAdminTable(data["Admin Data"]);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to add admin',
                });
            });
        }
    });
}



function updateAdminTable(newAdmin) {
    const adminTableBody = document.querySelector('#adminTable tbody');
    
    const row = document.createElement('tr');
    row.innerHTML = `
        
        <td>${newAdmin.name}</td>
        <td>${newAdmin.phone_number}</td>
        <td>${newAdmin.user_name}</td>
        <td>${newAdmin.role}</td>
        <td>Active</td>  <!-- Assuming the default status is active -->
        <td>${newAdmin.created_at}</td>
        <td>${newAdmin.updated_at}</td>
        <td>
            <!-- Add your edit/toggle actions here -->
            <button style="background-color:#468c9b; width:100px" onclick="editAdmin(${newAdmin.admin_id})">Edit</button>
            <button class="btn-toggle onclick="toggleAdmin(${newAdmin.admin_id})">Deactivate</button>
        </td>
    `;

    // Append the new row to the table body
    adminTableBody.appendChild(row);
}
const token = sessionStorage.getItem('token');

function fetchClients() {
    const token = sessionStorage.getItem('token');
    const requestOptions = {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        redirect: 'follow'
    };

    fetch("https://volta.sy/api/Dash/ShowAllClient", requestOptions)
        .then(response => response.json())
        .then(result => {
            if (result.msg === "Successfully ") {
                const tableBody = document.getElementById("clientTableBody");
                tableBody.innerHTML = ""; // Clear existing table rows

                result['All Client'].forEach(client => {
                    let actionButton = client.is_active ? 
                        `<button style="background-color: red;" onclick="toggleClient(${client.client_id}, false)">Deactivate</button>` :
                        `<button style="background-color: green;" onclick="toggleClient(${client.client_id}, true)">Activate</button>`;

                    let row = `
                        <tr>
                      
                            <td>${client.name}</td>
                            <td>${client.phone_number}</td>
                            <td>${client.user_name}</td>
                            <td>${client.home_address}</td>
                            <td>${client.technical_expert.name}</td>
                            <td>${client.connection_code}</td>
                            <td>
                                <button style="background-color: #468c9b; width: 100px;" onclick="editClient(${client.client_id}, '${client.name}', '${client.phone_number}', '${client.home_address}', '${client.user_name}', '${client.technical_expert.user_name}')">Edit</button>
                                ${actionButton}
                                <button style="background-color: #468c9b; color: white;" onclick="showSolarSystem(${client.client_id})">Show the Solar System</button>
                                
                            </td>
                        </tr>
                    `;
                    tableBody.innerHTML += row;
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'No clients found',
                    text: 'There are no client accounts available.'
                });
            }
        })
        .catch(error => {
            console.error('Error fetching clients:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to fetch client data.'
            });
        });
}
function showSolarSystem(client_id) {
    const url = `solar_system.html?client_id=${client_id}`;
    window.open(url, '_blank');
}
function toggleClient(client_id, activate) {
    const token = sessionStorage.getItem('token');
    const url = activate ? 
        `https://volta.sy/api/Dash/ActivateClient?client_id=${client_id}` :
        `https://volta.sy/api/Dash/DeactivateClient?client_id=${client_id}`;

    fetch(url, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(result => {
        if (result.msg.includes("successfully")) {
            Swal.fire({
                icon: 'success',
                title: `Client ${activate ? 'activated' : 'deactivated'} successfully`,
                showConfirmButton: false,
                timer: 1500
            });
            fetchClients(); // Reload the client list
        } else if (result.msg.includes("already")) {
            Swal.fire({
                icon: 'info',
                title: `Client already ${activate ? 'activated' : 'deactivated'}`,
                text: `This client is already ${activate ? 'activated' : 'deactivated'}.`
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Validation Error',
                text: result.msg
            });
        }
    })
    .catch(error => {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to update client status.'
        });
    });
}


function editClient(client_id, name, phone_number, home_address, user_name, technical_user_name) {
    fetchTechnicalExperts().then(experts => {
        const options = experts.map(expert => 
            `<option value="${expert.user_name}" ${expert.user_name === technical_user_name ? 'selected' : ''}>
                ${expert.name}
            </option>`
        ).join('');

        Swal.fire({
            title: 'Edit Client Data',
            html:
                `<div style="display: flex; flex-direction: column; gap: 1rem;">
                    <input id="editClientName" class="swal2-input" placeholder="Name" value="${name}">
                    <input id="editClientPhoneNumber" class="swal2-input" placeholder="Phone Number" value="${phone_number}">
                    <input id="editClientHomeAddress" class="swal2-input" placeholder="Home Address" value="${home_address}">
                    <input id="editClientUsername" class="swal2-input" placeholder="Username" value="${user_name}">
                    <select id="editClientTechUsername" class="swal2-select">
                        ${options}
                    </select>
                </div>`,
            focusConfirm: false,
            showCancelButton: true,
            confirmButtonText: 'Save Changes',
            cancelButtonText: 'Cancel',
            preConfirm: () => {
                const name = document.getElementById('editClientName').value.trim();
                const phone_number = document.getElementById('editClientPhoneNumber').value.trim();
                const home_address = document.getElementById('editClientHomeAddress').value.trim();
                const user_name = document.getElementById('editClientUsername').value.trim();
                const technical_user_name = document.getElementById('editClientTechUsername').value;

                let errors = [];

                // Validate name
                if (!name) {
                    errors.push('Name is required.');
                } else if (/\d/.test(name) || /[!@#$%^&*(),.?":{}|<>]/.test(name)) {
                    errors.push('Name should not contain numbers or special characters.');
                }

                // Validate phone number length
                if (!phone_number) {
                    errors.push('Phone Number is required.');
                } else if (!/^\d{10,15}$/.test(phone_number)) {
                    errors.push('Phone Number must be between 10 and 15 digits.');
                }

                // Validate other fields
                if (!home_address) errors.push('Home Address is required.');
                if (!user_name) errors.push('Username is required.');
                if (!technical_user_name) errors.push('Technical Expert is required.');

                if (errors.length > 0) {
                    Swal.showValidationMessage(errors.join('<br>'));
                    return false; // Prevent form submission
                }

                return {
                    name,
                    phone_number,
                    home_address,
                    user_name,
                    technical_user_name
                };
            }
        }).then((result) => {
            if (result.isConfirmed) {
                submitClientEdit(client_id, result.value);
            }
        });
    }).catch(error => {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to load technical experts for dropdown.'
        });
    });
}
fetchClients();

// Function to submit the edited client data
function submitClientEdit(client_id, editedData) {
    const token = sessionStorage.getItem('token');

    let queryParams = `?client_id=${client_id}`;
    if (editedData.name) queryParams += `&name=${editedData.name}`;
    if (editedData.phone_number) queryParams += `&phone_number=${editedData.phone_number}`;
    if (editedData.home_address) queryParams += `&home_address=${editedData.home_address}`;
    if (editedData.user_name) queryParams += `&user_name=${editedData.user_name}`;
    if (editedData.technical_user_name) queryParams += `&technical_user_name=${editedData.technical_user_name}`;

    fetch(`https://volta.sy/api/Dash/EditClientData${queryParams}`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(result => {
        if (result.msg === "Successfully Edit") {
            Swal.fire({
                icon: 'success',
                title: 'Client data updated successfully',
                showConfirmButton: false,
                timer: 1500
            });
            fetchClients(); // Reload the updated client list
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Validation Error',
                text: result.msg
            });
        }
    })
    .catch(error => {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to update client data.'
        });
    });
}
document.addEventListener('DOMContentLoaded', (event) => {
    // Function to show the SweetAlert form for adding a new panel
    document.getElementById('Add_pannel').addEventListener('click', () => {
        Swal.fire({
            title: 'Add New Panel',
            html: `
                <input id="manufacturer" class="swal2-input" placeholder="Manufacturer">
                <input id="model" class="swal2-input" placeholder="Model">
                <input id="max_power_output_watt" class="swal2-input" placeholder="Max Power Output (Watt)">
                <input id="cell_type" class="swal2-input" placeholder="Cell Type">
                <input id="efficiency" class="swal2-input" placeholder="Efficiency">
                <input id="panel_type" class="swal2-input" placeholder="Panel Type">
            `,
            focusConfirm: false,
            preConfirm: () => {
                const manufacturer = Swal.getPopup().querySelector('#manufacturer').value
                const model = Swal.getPopup().querySelector('#model').value
                const maxPowerOutputWatt = Swal.getPopup().querySelector('#max_power_output_watt').value
                const cellType = Swal.getPopup().querySelector('#cell_type').value
                const efficiency = Swal.getPopup().querySelector('#efficiency').value
                const panelType = Swal.getPopup().querySelector('#panel_type').value

                if (!manufacturer || !model || !maxPowerOutputWatt || !cellType || !efficiency || !panelType) {
                    Swal.showValidationMessage(`Please fill out all fields`)
                }
                return {
                    manufacturer: manufacturer,
                    model: model,
                    max_power_output_watt: maxPowerOutputWatt,
                    cell_type: cellType,
                    efficiency: efficiency,
                    panel_type: panelType
                }
            }
        }).then((result) => {
            if (result.isConfirmed) {
                // Send data to the API
                fetch('https://volta.sy/api/Dash/AddPanel', {
                    method: 'POST',
                    headers: {
                        'Authorization': 'Bearer ' + sessionStorage.getItem('token'),
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        manufacturer: result.value.manufacturer,
                        model: result.value.model,
                        max_power_output_watt: result.value.max_power_output_watt,
                        cell_type: result.value.cell_type,
                        efficiency: result.value.efficiency,
                        panel_type: result.value.panel_type
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.msg === "Panel created successfully") {
                        Swal.fire({
                            position: 'top-end',
                            icon: 'success',
                            title: 'Panel added successfully',
                            showConfirmButton: false,
                            timer: 1500
                        });
                        loadPanelData(); // Refresh data
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Failed to add panel. Please check the input data.'
                        });
                    }
                })
                .catch(error => {
                    console.log('error', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to add panel.'
                    });
                });
            }
        })
    });

    // Function to fetch and display panel data
    function loadPanelData() {
        fetch('https://volta.sy/api/Dash/ShowAllPanel', {
            method: 'POST',
            headers: {
                'Authorization': 'Bearer ' + sessionStorage.getItem('token'),
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            const tableBody = document.getElementById('panelTableBody');
            tableBody.innerHTML = ''; // Clear existing table data
            
            if (data.msg === "Successfully ") {
                if (data['All Panel'].length > 0) {
                    data['All Panel'].forEach(panel => {
                        const row = `<tr>
                                
                                        <td>${panel.manufacturer}</td>
                                        <td>${panel.model}</td>
                                        <td>${panel.max_power_output_watt}</td>
                                        <td>${panel.cell_type}</td>
                                        <td>${panel.efficiency}</td>
                                        <td>${panel.panel_type}</td>
                                        <td>
                                          <button font-size:20px; style="background-color: #468c9b;  width: 100px; padding:15px" class="edit-panel" data-panel-id="${panel.panel_id}">Edit Panel</button>
                                        </td>
                                      </tr>`;
                        tableBody.innerHTML += row;
                    });
                    document.getElementById('showandhide_table_Pannel').style.display = 'block'; // Show the table section
                    // Add event listeners to edit buttons
                    document.querySelectorAll('.edit-panel').forEach(button => {
                        button.addEventListener('click', () => {
                            const panelId = button.getAttribute('data-panel-id');
                            const currentData = data['All Panel'].find(p => p.panel_id === parseInt(panelId));
                            editPanel(panelId, currentData); // Call the edit function
                        });
                    });
                } else {
                    Swal.fire({
                        icon: 'info',
                        title: 'No Panels Found',
                        text: 'No panels have been added yet.'
                    });
                }
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to load panel data.'
                });
            }
        })
        .catch(error => {
            console.log('error', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to load panel data.'
            });
        });
    }

    // Function to show the SweetAlert form for editing a panel
    function editPanel(panelId, currentData) {
        Swal.fire({
            title: 'Edit Panel',
            html: `
                <input id="panel_id" type="hidden" value="${panelId}">
                <input id="manufacturer" class="swal2-input" placeholder="Manufacturer" value="${currentData.manufacturer || ''}">
                <input id="model" class="swal2-input" placeholder="Model" value="${currentData.model || ''}">
                <input id="max_power_output_watt" class="swal2-input" placeholder="Max Power Output (Watt)" value="${currentData.max_power_output_watt || ''}">
                <input id="cell_type" class="swal2-input" placeholder="Cell Type" value="${currentData.cell_type || ''}">
                <input id="efficiency" class="swal2-input" placeholder="Efficiency" value="${currentData.efficiency || ''}">
<select id="panel_type" class="swal2-input" style="padding: 0.625em; font-size: 1em; border: 1px solid #d9d9d9; border-radius: 0.25em; background-color: #fff; width:65%; box-sizing: border-box; height: 2.5em; margin-top: 10px; height:60px">
    <option value="وجه واحد" ${currentData.panel_type === 'وجه واحد' ? 'selected' : ''}>وجه واحد</option>
    <option value="وجهان" ${currentData.panel_type === 'وجهان' ? 'selected' : ''}>وجهان</option>
</select>

            `,
            focusConfirm: false,
            preConfirm: () => {
                const panelId = Swal.getPopup().querySelector('#panel_id').value
                const manufacturer = Swal.getPopup().querySelector('#manufacturer').value
                const model = Swal.getPopup().querySelector('#model').value
                const maxPowerOutputWatt = Swal.getPopup().querySelector('#max_power_output_watt').value
                const cellType = Swal.getPopup().querySelector('#cell_type').value
                const efficiency = Swal.getPopup().querySelector('#efficiency').value
                const panelType = Swal.getPopup().querySelector('#panel_type').value

                if (!panelId || (!manufacturer && !model && !maxPowerOutputWatt && !cellType && !efficiency && !panelType)) {
                    Swal.showValidationMessage(`Please fill out the Panel ID and at least one field to update`)
                }
                return {
                    panel_id: panelId,
                    manufacturer: manufacturer,
                    model: model,
                    max_power_output_watt: maxPowerOutputWatt,
                    cell_type: cellType,
                    efficiency: efficiency,
                    panel_type: panelType
                }
            }
        }).then((result) => {
            if (result.isConfirmed) {
                // Build the query string with only the updated fields
                let query = `panel_id=${result.value.panel_id}`;
                for (const key in result.value) {
                    if (result.value[key] && key !== 'panel_id') {
                        query += `&${key}=${encodeURIComponent(result.value[key])}`;
                    }
                }

                // Send data to the API
                fetch(`https://volta.sy/api/Dash/EditPanelData?${query}`, {
                    method: 'POST',
                    headers: {
                        'Authorization': 'Bearer ' + sessionStorage.getItem('token'),
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.msg === "Successfully Edit") {
                        Swal.fire({
                            position: 'top-end',
                            icon: 'success',
                            title: 'Panel data updated successfully',
                            showConfirmButton: false,
                            timer: 1500
                        });
                        loadPanelData(); // Refresh data
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Failed to update panel data. Please check the input data.'
                        });
                    }
                })
                .catch(error => {
                    console.log('error', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to update panel data.'
                    });
                });
            }
        })
    }

    // Call the function to load panel data when the page loads
    loadPanelData();
});

function fetchBatteryData() {
    var token = sessionStorage.getItem('token'); // Assuming the token is stored in sessionStorage
    var requestOptions = {
        method: 'POST',
        headers: {
            'Authorization': 'Bearer ' + token,
        },
        redirect: 'follow'
    };

    fetch("https://volta.sy/api/Dash/ShowAllBattery", requestOptions)
        .then(response => response.json())
        .then(result => {
            if (result.msg === "Successfully ") {
                populateBatteryTable(result['All Battery']);
            } else {
                Swal.fire('Error', 'Failed to fetch battery data', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Error', 'An error occurred while fetching battery data', 'error');
        });
}

function populateBatteryTable(batteryData) {
    var tableBody = document.querySelector('#deviceTable tbody');
    tableBody.innerHTML = ""; // Clear the table before populating

    batteryData.forEach(battery => {
        var row = document.createElement('tr');

        var createdAt = new Date(battery.created_at).toLocaleString(`en-GB`);
        var updatedAt = new Date(battery.updated_at).toLocaleString(`en-GB`);

        row.innerHTML = `
            <td>${battery.battery_type}</td>
            <td>${battery.battery_capacity}</td>
            <td>${battery.maximum_watt_battery}</td>
            <td>${battery.absorb_stage_volts}</td>
            <td>${battery.float_stage_volts}</td>
            <td>${battery.equalize_stage_volts}</td>
            <td>${battery.equalize_interval_days}</td>
            <td>${battery.seting_switches}</td>
            <td>${createdAt}</td>
            <td>${updatedAt}</td>
            <td>
                <button style="background-color: #579db8;" onclick="editBattery(${battery.battery_id}, '${battery.battery_type}', '${battery.battery_capacity}', '${battery.maximum_watt_battery}', '${battery.absorb_stage_volts}', '${battery.float_stage_volts}', '${battery.equalize_stage_volts}', '${battery.equalize_interval_days}', '${battery.seting_switches}')">Edit</button>
            </td>
        `;

        tableBody.appendChild(row);
    });
}



function addBattery() {
    Swal.fire({
        title: 'Add New Battery',
        html:
            '<input id="battery_type" class="swal2-input" placeholder="Battery Type">' +
            '<input id="battery_capacity" class="swal2-input" placeholder="Battery Capacity">' +
            '<input id="maximum_watt_battery" class="swal2-input" placeholder="Maximum Watt Battery">' +
            '<input id="absorb_stage_volts" class="swal2-input" placeholder="Absorb Stage Volts">' +
            '<input id="float_stage_volts" class="swal2-input" placeholder="Float Stage Volts">' +
            '<input id="equalize_stage_volts" class="swal2-input" placeholder="Equalize Stage Volts">' +
            '<input id="equalize_interval_days" class="swal2-input" placeholder="Equalize Interval Days">' +
            '<input id="seting_switches" class="swal2-input" placeholder="Setting Switches">',
        focusConfirm: false,
        showCancelButton: true, // إظهار زر Cancel
        confirmButtonText: 'OK', // نص زر OK
        cancelButtonText: 'Cancel', // نص زر Cancel
        preConfirm: () => {
            const batteryType = document.getElementById('battery_type').value.trim();
            const batteryCapacity = document.getElementById('battery_capacity').value.trim();
            const maxWattBattery = document.getElementById('maximum_watt_battery').value.trim();
            const absorbVolts = document.getElementById('absorb_stage_volts').value.trim();
            const floatVolts = document.getElementById('float_stage_volts').value.trim();
            const equalizeVolts = document.getElementById('equalize_stage_volts').value.trim();
            const equalizeDays = document.getElementById('equalize_interval_days').value.trim();
            const settingSwitches = document.getElementById('seting_switches').value.trim();

            // Validation
            if (!batteryType || !batteryCapacity || !maxWattBattery || !absorbVolts || 
                !floatVolts || !equalizeVolts || !equalizeDays || !settingSwitches) {
                Swal.showValidationMessage('Please fill all fields');
                return;
            }

            if (isNaN(batteryCapacity) || batteryCapacity <= 0) {
                Swal.showValidationMessage('Battery Capacity must be a positive number');
                return;
            }

            if (isNaN(maxWattBattery) || maxWattBattery <= 0) {
                Swal.showValidationMessage('Maximum Watt Battery must be a positive number');
                return;
            }

            if (isNaN(absorbVolts) || isNaN(floatVolts) || isNaN(equalizeVolts)) {
                Swal.showValidationMessage('Voltage values must be numbers');
                return;
            }

            if (isNaN(equalizeDays) || equalizeDays < 0) {
                Swal.showValidationMessage('Equalize Interval Days must be a non-negative number');
                return;
            }

            return {
                battery_type: batteryType,
                battery_capacity: batteryCapacity,
                maximum_watt_battery: maxWattBattery,
                absorb_stage_volts: absorbVolts,
                float_stage_volts: floatVolts,
                equalize_stage_volts: equalizeVolts,
                equalize_interval_days: equalizeDays,
                seting_switches: settingSwitches
            };
        }
    }).then((result) => {
        if (result.isConfirmed) {
            const batteryData = result.value;

            const token = sessionStorage.getItem('token');
            const requestOptions = {
                method: 'POST',
                headers: {
                    'Authorization': 'Bearer ' + token,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(batteryData),
                redirect: 'follow'
            };

            fetch("https://volta.sy/api/Dash/AddBattery", requestOptions)
                .then(response => response.json())
                .then(result => {
                    if (result.msg === "Panel created successfully") {
                        Swal.fire('Success', 'Battery added successfully', 'success');
                        fetchBatteryData(); // Refresh table after adding battery
                    } else {
                        Swal.fire('Error', result.msg, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to add battery', 'error');
                });
        }
    });
}



function editBattery(battery_id, battery_type, battery_capacity, maximum_watt_battery, absorb_stage_volts, float_stage_volts, equalize_stage_volts, equalize_interval_days, seting_switches) {
    Swal.fire({
        title: 'Edit Battery Data',
        html:
            `<input id="battery_type" class="swal2-input" placeholder="Battery Type" value="${battery_type || ''}">` +
            `<input id="battery_capacity" class="swal2-input" placeholder="Battery Capacity" value="${battery_capacity || ''}">` +
            `<input id="maximum_watt_battery" class="swal2-input" placeholder="Maximum Watt Battery" value="${maximum_watt_battery || ''}">` +
            `<input id="absorb_stage_volts" class="swal2-input" placeholder="Absorb Stage Volts" value="${absorb_stage_volts || ''}">` +
            `<input id="float_stage_volts" class="swal2-input" placeholder="Float Stage Volts" value="${float_stage_volts || ''}">` +
            `<input id="equalize_stage_volts" class="swal2-input" placeholder="Equalize Stage Volts" value="${equalize_stage_volts || ''}">` +
            `<input id="equalize_interval_days" class="swal2-input" placeholder="Equalize Interval Days" value="${equalize_interval_days || ''}">` +
            `<input id="seting_switches" class="swal2-input" placeholder="Setting Switches" value="${seting_switches || ''}">`,
        focusConfirm: false,
        showCancelButton: true,
        confirmButtonText: 'OK',
        cancelButtonText: 'Cancel',
        preConfirm: () => {
            const batteryType = document.getElementById('battery_type').value.trim();
            const batteryCapacity = document.getElementById('battery_capacity').value.trim();
            const maxWattBattery = document.getElementById('maximum_watt_battery').value.trim();
            const absorbVolts = document.getElementById('absorb_stage_volts').value.trim();
            const floatVolts = document.getElementById('float_stage_volts').value.trim();
            const equalizeVolts = document.getElementById('equalize_stage_volts').value.trim();
            const equalizeDays = document.getElementById('equalize_interval_days').value.trim();
            const settingSwitches = document.getElementById('seting_switches').value.trim();

            // Validation
            const validations = [];
            if (!batteryType) validations.push('Battery Type is required.');
            if (!batteryCapacity) validations.push('Battery Capacity is required.');
            if (!maxWattBattery) validations.push('Maximum Watt Battery is required.');
            if (!absorbVolts) validations.push('Absorb Stage Volts is required.');
            if (!floatVolts) validations.push('Float Stage Volts is required.');
            if (!equalizeVolts) validations.push('Equalize Stage Volts is required.');
            if (!equalizeDays) validations.push('Equalize Interval Days is required.');
            if (!settingSwitches) validations.push('Setting Switches is required.');

            // Check for numeric values
            if (isNaN(batteryCapacity) || batteryCapacity <= 0) {
                validations.push('Battery Capacity must be a positive number.');
            }
            if (isNaN(maxWattBattery) || maxWattBattery <= 0) {
                validations.push('Maximum Watt Battery must be a positive number.');
            }
            if (isNaN(absorbVolts) || isNaN(floatVolts) || isNaN(equalizeVolts)) {
                validations.push('Voltage values must be numbers.');
            }
            if (isNaN(equalizeDays) || equalizeDays < 0) {
                validations.push('Equalize Interval Days must be a non-negative number.');
            }

            // Show validation messages
            if (validations.length > 0) {
                Swal.showValidationMessage(validations.join(' '));
                return;
            }

            return {
                battery_id: battery_id,
                battery_type: batteryType,
                battery_capacity: batteryCapacity,
                maximum_watt_battery: maxWattBattery,
                absorb_stage_volts: absorbVolts,
                float_stage_volts: floatVolts,
                equalize_stage_volts: equalizeVolts,
                equalize_interval_days: equalizeDays,
                seting_switches: settingSwitches
            };
        }
    }).then((result) => {
        if (result.isConfirmed) {
            const updatedData = result.value;

            const token = sessionStorage.getItem('token');
            const requestOptions = {
                method: 'POST',
                headers: {
                    'Authorization': 'Bearer ' + token,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updatedData),
                redirect: 'follow'
            };

            fetch("https://volta.sy/api/Dash/EditBatteryData", requestOptions)
                .then(response => response.json())
                .then(result => {
                    if (result.msg === "Successfully Edit") {
                        Swal.fire('Success', 'Battery data updated successfully', 'success');
                        fetchBatteryData(); // Refresh table after updating
                    } else {
                        Swal.fire('Error', result.msg, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to update battery data', 'error');
                });
        }
    });
}



fetchBatteryData();



  document.addEventListener('DOMContentLoaded', function() {
    fetchInverters();
});

function fetchInverters() {
    const token = sessionStorage.getItem('token'); // الحصول على التوكن من التخزين

    fetch("https://volta.sy/api/Dash/ShowAllInverter", {
        method: 'POST',
        headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(result => {
        if (result.msg === "Successfully ") {
            populateInverterTable(result['All Inverter']);
        } else {
            Swal.fire('Info', 'No inverters found.', 'info');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        Swal.fire('Error', 'Failed to fetch inverter data', 'error');
    });
}

function populateInverterTable(inverters) {
    const tableBody = document.getElementById('inveter');
    tableBody.innerHTML = ''; // مسح المحتوى القديم

    inverters.forEach(inverter => {
        const row = document.createElement('tr');
        row.innerHTML = `

            <td>${inverter.model_name}</td>
            <td>${inverter.operating_temperature}</td>
            <td>${inverter.invert_mode_rated_power}</td>
            <td>${inverter.invert_mode_dc_input}</td>
            <td>${inverter.invert_mode_ac_output}</td>
            <td>${inverter.ac_charger_mode_ac_input}</td>
            <td>${inverter.ac_charger_mode_ac_output}</td>
            <td>${inverter.ac_charger_mode_dc_output}</td>
            <td><button onclick='editInverterData(${JSON.stringify(inverter)})'>Edit</button></td>
        `;
        tableBody.appendChild(row);
    });
}

function editInverterData(inverter) {
    Swal.fire({
        title: 'Edit Inverter Data',
        html: `
          <input id="model_name" class="swal2-input" value="${inverter.model_name}" placeholder="Model Name">
          <input id="operating_temperature" class="swal2-input" value="${inverter.operating_temperature}" placeholder="Operating Temperature">
          <input id="rated_power" class="swal2-input" value="${inverter.invert_mode_rated_power}" placeholder="Rated Power">
          <input id="dc_input" class="swal2-input" value="${inverter.invert_mode_dc_input}" placeholder="DC Input">
          <input id="ac_output" class="swal2-input" value="${inverter.invert_mode_ac_output}" placeholder="AC Output">
          <input id="ac_input" class="swal2-input" value="${inverter.ac_charger_mode_ac_input}" placeholder="AC Charger Input">
          <input id="ac_charger_output" class="swal2-input" value="${inverter.ac_charger_mode_ac_output}" placeholder="AC Charger Output">
          <input id="dc_output" class="swal2-input" value="${inverter.ac_charger_mode_dc_output}" placeholder="DC Output">
        `,
        confirmButtonText: 'Save',
        focusConfirm: false,
        preConfirm: () => {
          const modelName = document.getElementById('model_name').value;
          const operatingTemperature = document.getElementById('operating_temperature').value;
          const ratedPower = document.getElementById('rated_power').value;
          const dcInput = document.getElementById('dc_input').value;
          const acOutput = document.getElementById('ac_output').value;
          const acInput = document.getElementById('ac_input').value;
          const acChargerOutput = document.getElementById('ac_charger_output').value;
          const dcOutput = document.getElementById('dc_output').value;

          const updatedFields = {
            inverters_id: inverter.inverters_id,
          };

          if (modelName !== inverter.model_name) updatedFields.model_name = modelName;
          if (operatingTemperature !== inverter.operating_temperature) updatedFields.operating_temperature = operatingTemperature;
          if (ratedPower !== inverter.invert_mode_rated_power) updatedFields.invert_mode_rated_power = ratedPower;
          if (dcInput !== inverter.invert_mode_dc_input) updatedFields.invert_mode_dc_input = dcInput;
          if (acOutput !== inverter.invert_mode_ac_output) updatedFields.invert_mode_ac_output = acOutput;
          if (acInput !== inverter.ac_charger_mode_ac_input) updatedFields.ac_charger_mode_ac_input = acInput;
          if (acChargerOutput !== inverter.ac_charger_mode_ac_output) updatedFields.ac_charger_mode_ac_output = acChargerOutput;
          if (dcOutput !== inverter.ac_charger_mode_dc_output) updatedFields.ac_charger_mode_dc_output = dcOutput;

          return updatedFields;
        }
    }).then((result) => {
        if (result.isConfirmed) {
          const updatedData = result.value;
          const token = sessionStorage.getItem('token'); // الحصول على التوكن من التخزين

          fetch("https://volta.sy/api/Dash/EditInverterData", {
            method: 'POST',
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(updatedData)
          })
          .then(response => response.json())
          .then(data => {
            if (data.msg === "Successfully Edit") {
              Swal.fire({
                icon: 'success',
                title: 'Inverter Updated',
                text: 'The inverter data has been updated successfully!'
              });
              fetchInverters(); // تحديث البيانات بعد التعديل
            } else {
              Swal.fire({
                icon: 'error',
                title: 'Error',
                text: data.msg || 'Failed to update inverter data.'
              });
            }
          })
          .catch(error => {
            Swal.fire({
              icon: 'error',
              title: 'Error',
              text: 'Something went wrong while updating the inverter.'
            });
            console.error('Error:', error);
          });
        }
    });
}


document.getElementById("Add_Inverter").addEventListener("click", function() {
    Swal.fire({
      title: 'Add New Inverter',
      html: `
        <input id="model_name" class="swal2-input" placeholder="Model Name">
        <input id="operating_temperature" class="swal2-input" placeholder="Operating Temperature">
        <input id="invert_mode_rated_power" class="swal2-input" placeholder="Invert Mode Rated Power">
        <input id="invert_mode_dc_input" class="swal2-input" placeholder="Invert Mode DC Input">
        <input id="invert_mode_ac_output" class="swal2-input" placeholder="Invert Mode AC Output">
        <input id="ac_charger_mode_ac_input" class="swal2-input" placeholder="AC Charger Mode AC Input">
        <input id="ac_charger_mode_ac_output" class="swal2-input" placeholder="AC Charger Mode AC Output">
        <input id="ac_charger_mode_dc_output" class="swal2-input" placeholder="AC Charger Mode DC Output">
        <input id="ac_charger_mode_max_charger" class="swal2-input" placeholder="AC Charger Mode Max Charger">
        <input id="solar_charger_mode_rated_power" class="swal2-input" placeholder="Solar Charger Mode Rated Power">
        <input id="solar_charger_mode_system_voltage" class="swal2-input" placeholder="Solar Charger Mode System Voltage">
        <input id="solar_charger_mode_mppt_voltage_range" class="swal2-input" placeholder="Solar Charger Mode MPPT Voltage Range">
        <input id="solar_charger_mode_max_solar_voltage" class="swal2-input" placeholder="Solar Charger Mode Max Solar Voltage">
      `,
      focusConfirm: false,
      preConfirm: () => {
        return {
          model_name: document.getElementById('model_name').value,
          operating_temperature: document.getElementById('operating_temperature').value,
          invert_mode_rated_power: document.getElementById('invert_mode_rated_power').value,
          invert_mode_dc_input: document.getElementById('invert_mode_dc_input').value,
          invert_mode_ac_output: document.getElementById('invert_mode_ac_output').value,
          ac_charger_mode_ac_input: document.getElementById('ac_charger_mode_ac_input').value,
          ac_charger_mode_ac_output: document.getElementById('ac_charger_mode_ac_output').value,
          ac_charger_mode_dc_output: document.getElementById('ac_charger_mode_dc_output').value,
          ac_charger_mode_max_charger: document.getElementById('ac_charger_mode_max_charger').value,
          solar_charger_mode_rated_power: document.getElementById('solar_charger_mode_rated_power').value,
          solar_charger_mode_system_voltage: document.getElementById('solar_charger_mode_system_voltage').value,
          solar_charger_mode_mppt_voltage_range: document.getElementById('solar_charger_mode_mppt_voltage_range').value,
          solar_charger_mode_max_solar_voltage: document.getElementById('solar_charger_mode_max_solar_voltage').value
        }
      }
    }).then((result) => {
      if (result.isConfirmed) {
        // إعداد بيانات الطلب
        const token = sessionStorage.getItem("token"); // جلب التوكن من التخزين المؤقت
        const url = "https://volta.sy/api/Dash/AddInverter";
        const params = result.value; // الحصول على بيانات النموذج

        // إعداد الطلب
        fetch(url, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}` 
          },
          body: JSON.stringify(params) 
        })
        .then(response => response.json())
        .then(result => {
          if (result.msg === "Panel created successfully") {
            Swal.fire({
              position: "top-end",
              icon: "success",
              title: "Inverter added successfully",
              showConfirmButton: false,
              timer: 1500
            });
          } else {
            Swal.fire({
              icon: "error",
              title: "Oops...",
              text: result.msg || "Failed to add inverter!"
            });
          }
        })
        .catch(error => {
          console.log('error', error);
          Swal.fire({
            icon: "error",
            title: "Oops...",
            text: "There was an error adding the inverter!"
          });
        });
      }
    });
  });
  document.addEventListener("DOMContentLoaded", function() {
    fetchRequestData();
  });
  
  function fetchRequestData() {
    const token = sessionStorage.getItem('token'); // Retrieve the token from session storage

    if (!token) {
        Swal.fire({
            icon: 'error',
            title: 'No token found',
            text: 'Please log in to continue.'
        });
        return;
    }

    fetch("https://volta.sy/api/Dash/ShowAllRequestEquipment", {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Successfully ") {
            const tableBody = document.getElementById('Equipment_Request');
            tableBody.innerHTML = ''; // Clear existing rows

            data["All Equipment Request"].forEach(request => {
                const expertName = request.technical_expert.name || 'N/A'; // Use expert's name here
                const createdAtFormatted = request.created_at ? new Date(request.created_at).toLocaleString() : 'N/A'; // Format created_at

                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${expertName}</td>
                    <td>${request.name || 'N/A'}</td>
                    <td>${request.number_of_broadcast_device || 'N/A'}</td>
                    <td>${request.number_of_port || 'N/A'}</td>
                    <td>${request.number_of_socket || 'N/A'}</td>
                    <td style="display:none">
                        <button onclick="showDetails('panel', ${request.panel_id || 'N/A'})">Panel Details</button>
                    </td>
                    <td>${request.number_of_panel || 'N/A'}</td>
                    <td style="display:none">
                        <button onclick="showDetails('battery', ${request.battery_id || 'N/A'})">Battery Details</button>
                    </td>
                    <td>${request.number_of_battery || 'N/A'}</td>
                    <td style="display:none">
                        <button onclick="showDetails('inverter', ${request.inverters_id || 'N/A'})">Inverter Details</button>
                    </td>
                    <td>${request.number_of_inverter || 'N/A'}</td>
                    <td>${request.additional_equipment || 'N/A'}</td>
                    <td>${request.status || 'N/A'}</td>
                    <td>${request.commet || 'N/A'}</td>
                    <td>${createdAtFormatted}</td> <!-- Display formatted created_at -->
                    <td style="display:none">
                        <button style="background-color:#468c9b; width:100px;" class="approve-btn" onclick="approveRequest(${request.request_equipment_id})">Approve</button>
                        <button class="reject-btn" onclick="rejectRequest(${request.request_equipment_id})">Reject</button>
                    </td>
                    <td>
                        <button 
                            onclick="showRequestDetails(${request.request_equipment_id})" 
                            style="background-color: #468c9b; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-size: 16px;">
                            View Request Details
                        </button>
                    </td>
                `;
                tableBody.appendChild(row);
            });

            // Show the table after data is loaded
            document.getElementById('showandhide_table_Equipment_Request').style.display = 'block';
        } else {
            Swal.fire({
                icon: 'info',
                title: 'No Requests Found',
                text: 'There are no equipment requests available.'
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to fetch requests. Please try again.'
        });
    });
}



function showDetails(type, id) {
    const token = sessionStorage.getItem('token'); // Retrieve the token from session storage

    if (!id || id === 'N/A') {
        Swal.fire({
            icon: 'info',
            title: `${type.charAt(0).toUpperCase() + type.slice(1)} Details`,
            text: 'No details available for this item.'
        });
        return;
    }

    if (!token) {
        Swal.fire({
            icon: 'error',
            title: 'No token found',
            text: 'Please log in to continue.'
        });
        return;
    }

    let apiUrl;
    let requestBody;

    switch (type) {
        case 'panel':
            apiUrl = 'https://volta.sy/api/Dash/ShowAllPanel';
            requestBody = {}; // No need to send ID for this API; it returns all panels
            break;
        case 'battery':
            apiUrl = 'https://volta.sy/api/Dash/ShowAllBattery';
            requestBody = {}; // No need to send ID for this API; it returns all batteries
            break;
        case 'inverter':
            apiUrl = 'https://volta.sy/api/Dash/ShowAllInverter';
            requestBody = {}; // No need to send ID for this API; it returns all inverters
            break;
        default:
            Swal.fire({
                icon: 'error',
                title: 'Invalid Type',
                text: 'Details type is not recognized.'
            });
            return;
    }

    fetch(apiUrl, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(requestBody)
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Successfully ") {
            let details = null;

            switch (type) {
                case 'panel':
                    details = data["All Panel"].find(panel => panel.panel_id === id);
                    break;
                case 'battery':
                    details = data["All Battery"].find(battery => battery.battery_id === id);
                    break;
                case 'inverter':
                    details = data["All Inverter"].find(inverter => inverter.inverters_id === id);
                    break;
            }

            if (details) {
                Swal.fire({
                    icon: 'info',
                    title: `${type.charAt(0).toUpperCase() + type.slice(1)} Details`,
                    html: `
                        <p>ID: ${details[`${type}_id`] || 'N/A'}</p>
                        ${type === 'panel' ? `
                            <p>Manufacturer: ${details.manufacturer || 'N/A'}</p>
                            <p>Model: ${details.model || 'N/A'}</p>
                            <p>Max Power Output: ${details.max_power_output_watt || 'N/A'}</p>
                            <p>Cell Type: ${details.cell_type || 'N/A'}</p>
                            <p>Efficiency: ${details.efficiency || 'N/A'}</p>
                            <p>Panel Type: ${details.panel_type || 'N/A'}</p>
                        ` : type === 'battery' ? `
                            <p>Type: ${details.battery_type || 'N/A'}</p>
                            <p>Absorb Stage Volts: ${details.absorb_stage_volts || 'N/A'}</p>
                            <p>Float Stage Volts: ${details.float_stage_volts || 'N/A'}</p>
                            <p>Equalize Stage Volts: ${details.equalize_stage_volts || 'N/A'}</p>
                            <p>Equalize Interval Days: ${details.equalize_interval_days || 'N/A'}</p>
                            <p>Setting Switches: ${details.seting_switches || 'N/A'}</p>
                        ` : type === 'inverter' ? `
                            <p>Model Name: ${details.model_name || 'N/A'}</p>
                            <p>Operating Temperature: ${details.operating_temperature || 'N/A'}</p>
                            <p>Invert Mode Rated Power: ${details.invert_mode_rated_power || 'N/A'}</p>
                            <p>Invert Mode DC Input: ${details.invert_mode_dc_input || 'N/A'}</p>
                            <p>Invert Mode AC Output: ${details.invert_mode_ac_output || 'N/A'}</p>
                            <p>AC Charger Mode AC Input: ${details.ac_charger_mode_ac_input || 'N/A'}</p>
                            <p>AC Charger Mode AC Output: ${details.ac_charger_mode_ac_output || 'N/A'}</p>
                            <p>AC Charger Mode DC Output: ${details.ac_charger_mode_dc_output || 'N/A'}</p>
                            <p>AC Charger Mode Max Charger: ${details.ac_charger_mode_max_charger || 'N/A'}</p>
                            <p>Solar Charger Mode Rated Power: ${details.solar_charger_mode_rated_power || 'N/A'}</p>
                            <p>Solar Charger Mode System Voltage: ${details.solar_charger_mode_system_voltage || 'N/A'}</p>
                            <p>Solar Charger Mode MPPT Voltage Range: ${details.solar_charger_mode_mppt_voltage_range || 'N/A'}</p>
                            <p>Solar Charger Mode Max Solar Voltage: ${details.solar_charger_mode_max_solar_voltage || 'N/A'}</p>
                        ` : ''}
                    `
                });
            } else {
                Swal.fire({
                    icon: 'info',
                    title: `${type.charAt(0).toUpperCase() + type.slice(1)} Details`,
                    text: 'Details could not be found.'
                });
            }
        } else {
            Swal.fire({
                icon: 'info',
                title: `${type.charAt(0).toUpperCase() + type.slice(1)} Details`,
                text: 'Details could not be fetched.'
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to fetch details. Please try again.'
        });
    });
}



  function showRequestDetails(requestId) {
    window.location.href = `request-details.html?requestId=${requestId}`;
  }
  
  
  function approveRequest(requestId) {
    const token = sessionStorage.getItem('token'); // Retrieve the token from session storage
  
    if (!token) {
      Swal.fire({
        icon: 'error',
        title: 'No token found',
        text: 'Please log in to continue.'
      });
      return;
    }
  
    const comment = 'تم الموافقة على الطلب سوف يتم شحنه اليك'; // Set the comment message
  
    fetch(`https://volta.sy/api/Dash/approved?request_equipment_id=${requestId}&commet=${encodeURIComponent(comment)}`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.msg === "Successfully status update") {
        Swal.fire({
          icon: 'success',
          title: 'Request Approved',
          text: 'The request has been approved successfully.'
        }).then(() => {
          // Refresh the table data after approval
          fetchRequestData();
        });
      } else if (data.msg === "Already Approved") {
        Swal.fire({
          icon: 'info',
          title: 'Already Approved',
          text: 'This request has already been approved.'
        });
      } else {
        Swal.fire({
          icon: 'error',
          title: 'Approval Failed',
          text: 'Failed to approve the request. Please try again.'
        });
      }
    })
    .catch(error => {
      console.error('Error:', error);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Failed to approve the request. Please try again.'
      });
    });
  }
  
  function rejectRequest(requestId) {
    const token = sessionStorage.getItem('token'); // Retrieve the token from session storage
  
    if (!token) {
      Swal.fire({
        icon: 'error',
        title: 'No token found',
        text: 'Please log in to continue.'
      });
      return;
    }
  
    // Prompt the user to enter a comment
    Swal.fire({
      title: 'Enter Comment',
      input: 'textarea',
      inputLabel: 'Comment',
      inputPlaceholder: 'Enter your comment here...',
      inputAttributes: {
        'aria-label': 'Enter your comment here'
      },
      showCancelButton: true,
      confirmButtonText: 'Reject',
      cancelButtonText: 'Cancel',
      inputValidator: (value) => {
        if (!value) {
          return 'You need to write something!';
        }
      }
    }).then((result) => {
      if (result.isConfirmed) {
        const comment = result.value; // Get the comment from the input
  
        fetch(`https://volta.sy/api/Dash/rejected?request_equipment_id=${requestId}&commet=${encodeURIComponent(comment)}`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        })
        .then(response => response.json())
        .then(data => {
          if (data.msg === "Successfully status update") {
            Swal.fire({
              icon: 'success',
              title: 'Request Rejected',
              text: 'The request has been rejected successfully.'
            }).then(() => {
              // Refresh the table data after rejection
              fetchRequestData();
            });
          } else if (data.msg === "This request has already been rejected.") {
            Swal.fire({
              icon: 'info',
              title: 'Already Rejected',
              text: 'This request has already been rejected.'
            });
          } else {
            Swal.fire({
              icon: 'error',
              title: 'Rejection Failed',
              text: 'Failed to reject the request. Please try again.'
            });
          }
        })
        .catch(error => {
          console.error('Error:', error);
          Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to reject the request. Please try again.'
          });
        });
      }
    });
  }
  


  function fetchBroadcastDevices() {
    const token = sessionStorage.getItem('token'); // الحصول على التوكن
    fetch("https://volta.sy/api/Dash/ShowAllDeviceBroadcast", {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Successfully ") {
            const devices = data["All Broadcast Device"];
            const tbody = document.getElementById("Broadcast_Device");
            if (tbody) {
                tbody.innerHTML = ""; // مسح البيانات الحالية

                devices.forEach(device => {
                    // حالة الجهاز (نشط أو غير نشط)
                    const statusText = device.status === "active" ? 'Active' : 'Inactive';
                    const statusColor = device.status === "active" ? 'green' : 'red';
                    
                    // إنشاء صفوف للجدول مع أزرار التفاصيل وتغيير الحالة والتعديل
                    const row = document.createElement("tr");
                    row.innerHTML = `
                        <td>${device.model || 'N/A'}</td>
                        <td>${device.version || 'N/A'}</td>
                        <td>${device.number_of_wired_port || 'N/A'}</td>
                        <td>${device.number_of_wireless_port || 'N/A'}</td>
                        <td>${device.ip_addrees || 'N/A'}</td>
                        <td style="color: ${statusColor}; font-weight: bold;">
                            ${statusText}
                        </td>
                        <td>
                            <button class="details-btn" data-id="${device.broadcast_device_id}" style="background-color: #579db8; color: white;">Details</button>
                            <button class="status-btn" data-id="${device.broadcast_device_id}" style="background-color: ${device.status === 'active' ? '#dc3545' : '#28a745'}; color: white;">
                                ${device.status === 'active' ? 'Deactivate' : 'Activate'}
                            </button>
                            <button class="edit-btn" data-id="${device.broadcast_device_id}" style="background-color: #468c9b; color: white;">
                                Edit
                            </button>
                            <button class="qr-btn" data-id="${device.broadcast_device_id}" style="background-color: #ffc107; color: white;">QR</button>
                        </td>
                    `;
                    tbody.appendChild(row);
                });

                // إضافة مستمع لزر التفاصيل
                document.querySelectorAll('.details-btn').forEach(button => {
                    button.addEventListener('click', function() {
                        const deviceId = this.getAttribute('data-id');
                        showDeviceBroadcastDetails(deviceId);
                    });
                });

                // إضافة مستمع لزر تغيير الحالة
                document.querySelectorAll('.status-btn').forEach(button => {
                    button.addEventListener('click', function() {
                        const deviceId = this.getAttribute('data-id');
                        toggleBroadcastDeviceStatus(deviceId, this);
                    });
                });

                // إضافة مستمع لزر التعديل
                document.querySelectorAll('.edit-btn').forEach(button => {
                    button.addEventListener('click', function() {
                        const deviceId = this.getAttribute('data-id');
                        editBroadcastDevice(deviceId);
                    });
                });

                // إضافة مستمع لزر QR
                document.querySelectorAll('.qr-btn').forEach(button => {
                    button.addEventListener('click', function() {
                        const deviceId = this.getAttribute('data-id');
                        generateQRCodeData(deviceId);
                    });
                });
            }
        }
    })
    .catch(error => console.log('error', error));
}
function generateQRCodeData(deviceId) {
    // Retrieve the token from session storage
    const token = sessionStorage.getItem('token');

    // Fetch QR code data from the server
    fetch(`https://volta.sy/api/Dash/GenerateQRCodeData?broadcast_device_id=${deviceId}`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        }
    })
    .then(response => {
        // Check if the response is ok
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        // Check if QR data generation was successful
        if (data.msg === "QR Data generated successfully") {
            // Parse the QR data
            const qrData = JSON.parse(data["QR Data"]);

            // Set the size for the QR code
            const qrCanvasSize = 222;
            const canvas = document.createElement('canvas');
            canvas.width = qrCanvasSize;
            canvas.height = qrCanvasSize;
            const ctx = canvas.getContext('2d');

            // Create the QR code URL
            const qrCodeUrl = `https://api.qrserver.com/v1/create-qr-code/?data=${encodeURIComponent(JSON.stringify(qrData))}&size=${qrCanvasSize}x${qrCanvasSize}`;
            const img = new Image();

            // Draw the QR code image onto the canvas once loaded
            img.onload = function() {
                ctx.drawImage(img, 0, 0, qrCanvasSize, qrCanvasSize);
                
                // Create a container for the QR code
                const qrContainer = document.createElement('div');
                qrContainer.appendChild(canvas);

                // Display the QR code in a SweetAlert modal
                Swal.fire({
                    title: 'QR Code',
                    html: qrContainer,
                    width: 380, // Larger window width
                    showCancelButton: true,
                    confirmButtonText: 'Cancel', // Changed from 'Download' to 'Cancel'
                    cancelButtonText: 'Print',
                    showCloseButton: true,
                    didOpen: () => {
                        const printButton = Swal.getCancelButton();
                        printButton.addEventListener('click', function() {
                            printQRCode(qrContainer);
                        });
                    },
                    didRender: () => {
                        const downloadButton = Swal.getConfirmButton();
                        downloadButton.addEventListener('click', function() {
                            // You can add functionality for download here if needed
                        });
                    },
                    padding: '2rem' // Spacing for aesthetics
                });
            };

            // Set the source of the image to generate the QR code
            img.src = qrCodeUrl;
        } else {
            // Handle errors if QR data generation fails
            Swal.fire({
                title: 'Error',
                text: data.msg || 'An error occurred while generating QR code data.',
                icon: 'error'
            });
        }
    })
    .catch(error => {
        // Log and show network errors
        console.error('Error:', error);
        Swal.fire({
            title: 'Error',
            text: 'An error occurred while generating QR code data. Please try again later.',
            icon: 'error'
        });
    });
}

function printQRCode(qrContainer) {
    const win = window.open('', '_blank');
    win.document.write('<html><head><title>Print QR Code</title></head><body>');
    win.document.write(qrContainer.innerHTML);
    win.document.write('</body></html>');
    win.document.close();
    win.print();
}
function editBroadcastDevice(deviceId) {
    const token = sessionStorage.getItem('token');

    fetch(`https://volta.sy/api/Dash/ShowDeviceBroadcast?broadcast_device_id=${deviceId}`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Successfully retrieved data") {
            const device = data["BroadcastDevice Data"];

            Swal.fire({
                title: 'Edit Broadcast Device',
                html: `
                    <input id="model" class="swal2-input" placeholder="Model" value="${device.model || ''}">
                    <input id="version" class="swal2-input" placeholder="Version" value="${device.version || ''}">
                    <input id="number_of_wired_port" class="swal2-input" placeholder="Number of Wired Ports" value="${device.number_of_wired_port || ''}">
                    <input id="number_of_wireless_port" class="swal2-input" placeholder="Number of Wireless Ports" value="${device.number_of_wireless_port || ''}">
                    <input id="ip_address" class="swal2-input" placeholder="IP Address" value="${device.ip_addrees || ''}">
                    <input id="socket_id" class="swal2-input" placeholder="Socket ID (if applicable)" value="${device.socket ? device.socket[0].socket_id || '' : ''}">
                    <input id="socket_model" class="swal2-input" placeholder="Socket Model (if applicable)" value="${device.socket ? device.socket[0].socket_model || '' : ''}">
                `,
                focusConfirm: false,
                showCancelButton: true,
                confirmButtonText: 'OK',
                cancelButtonText: 'Cancel',
                preConfirm: () => {
                    const model = document.getElementById('model').value;
                    const version = document.getElementById('version').value;
                    const numberOfWiredPort = document.getElementById('number_of_wired_port').value;
                    const numberOfWirelessPort = document.getElementById('number_of_wireless_port').value;
                    const ip_address = document.getElementById('ip_address').value;
                    const socketId = document.getElementById('socket_id').value;
                    const socketModel = document.getElementById('socket_model').value;

                  
                    if (!model) {
                        Swal.showValidationMessage('Model is required');
                        return false; 
                    }
                    if (!ip_address || !validateIP(ip_address)) {
                        Swal.showValidationMessage('Valid IP Address is required');
                        return false;
                    }

                    const body = { broadcast_device_id: deviceId };

                    if (model) body.model = model;
                    if (version) body.version = version;
                    if (numberOfWiredPort) body.number_of_wired_port = numberOfWiredPort;
                    if (numberOfWirelessPort) body.number_of_wireless_port = numberOfWirelessPort;
                    if (ip_address) body.ip_addrees = ip_address;
                    if (socketId && socketModel) {
                        body.sockets = [{ socket_id: socketId, socket_model: socketModel }];
                    }

                    return body;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch('https://volta.sy/api/Dash/EditBroadcastDeviceData', {
                        method: 'POST',
                        headers: {
                            'Authorization': `Bearer ${token}`,
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(result.value)
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.msg === "Broadcast device and sockets updated successfully") {
                            Swal.fire({
                                title: 'Success',
                                text: 'Broadcast device updated successfully.',
                                icon: 'success'
                            }).then(() => {
                                fetchBroadcastDevices();
                            });
                        } else {
                            Swal.fire({
                                title: 'Error',
                                text: 'An error occurred: ' + data.msg,
                                icon: 'error'
                            });
                        }
                    })
                    .catch(error => {
                        console.log('error', error);
                        Swal.fire({
                            title: 'Error',
                            text: 'An error occurred while updating the broadcast device.',
                            icon: 'error'
                        });
                    });
                }
            });
        } else {
            Swal.fire({
                title: 'Error',
                text: 'An error occurred while retrieving device details for editing.',
                icon: 'error'
            });
        }
    })
    .catch(error => {
        console.log('error', error);
        Swal.fire({
            title: 'Error',
            text: 'An error occurred while retrieving device details for editing.',
            icon: 'error'
        });
    });
}

function validateIP(ip) {
    const pattern = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    return pattern.test(ip);
}

function toggleBroadcastDeviceStatus(deviceId, button) {
    const token = sessionStorage.getItem('token'); // الحصول على التوكن
    fetch(`https://volta.sy/api/Dash/ChangeBroadcastDeviceStatus?broadcast_device_id=${deviceId}`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Broadcast Device status has been updated successfully") {
            Swal.fire({
                title: 'Success',
                text: 'Broadcast device status has been updated successfully.',
                icon: 'success'
            }).then(() => {
                // تحديث حالة الزر وحالة الجهاز في الجدول
                const newStatus = data.new_status;
                button.textContent = newStatus === 'active' ? 'Deactivate' : 'Activate';
                button.style.backgroundColor = newStatus === 'active' ? '#dc3545' : '#28a745';

                // تحديث حالة النص في الجدول
                const statusCell = button.closest('tr').querySelector('td:nth-child(6)');
                statusCell.textContent = newStatus === 'active' ? 'Active' : 'Inactive';
                statusCell.style.color = newStatus === 'active' ? 'green' : 'red';
            });
        } else {
            Swal.fire({
                title: 'Error',
                text: 'An error occurred while updating the broadcast device status.',
                icon: 'error'
            });
        }
    })
    .catch(error => {
        console.log('error', error);
        Swal.fire({
            title: 'Error',
            text: 'An error occurred while updating the broadcast device status.',
            icon: 'error'
        });
    });
}

function toggleBroadcastDeviceStatus(deviceId, button) {
    const token = sessionStorage.getItem('token'); // الحصول على التوكن
    fetch(`https://volta.sy/api/Dash/ChangeBroadcastDeviceStatus?broadcast_device_id=${deviceId}`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Broadcast Device status has been updated successfully") {
            Swal.fire({
                title: 'Success',
                text: 'Broadcast device status has been updated successfully.',
                icon: 'success'
            }).then(() => {
                // تحديث حالة الزر وحالة الجهاز في الجدول
                const newStatus = data.new_status;
                button.textContent = newStatus === 'active' ? 'Deactivate' : 'Activate';
                button.style.backgroundColor = newStatus === 'active' ? '#dc3545' : '#28a745';

                // تحديث حالة النص في الجدول
                const statusCell = button.closest('tr').querySelector('td:nth-child(6)');
                statusCell.textContent = newStatus === 'active' ? 'Active' : 'Inactive';
                statusCell.style.color = newStatus === 'active' ? 'green' : 'red';
            });
        } else {
            Swal.fire({
                title: 'Error',
                text: 'An error occurred while updating the broadcast device status.',
                icon: 'error'
            });
        }
    })
    .catch(error => {
        console.log('error', error);
        Swal.fire({
            title: 'Error',
            text: 'An error occurred while updating the broadcast device status.',
            icon: 'error'
        });
    });
}
function showDeviceBroadcastDetails(deviceId) {
    const token = sessionStorage.getItem('token'); // الحصول على التوكن
    fetch(`https://volta.sy/api/Dash/ShowDeviceBroadcast?broadcast_device_id=${deviceId}`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Successfully retrieved data") {
            const device = data["BroadcastDevice Data"];
            const client = data["Client Data"]; // بيانات العميل
            const sockets = device.socket ? device.socket.map(socket => `
                <tr>
                    <td>${socket.socket_id || 'N/A'}</td>
                    <td>${socket.socket_model || 'N/A'}</td>
                    <td>${socket.socket_version || 'N/A'}</td>
                    <td>${socket.socket_name || 'N/A'}</td>
                    <td>${socket.socket_connection_type || 'N/A'}</td>
                    <td style="color: ${socket.status === 1 ? 'green' : 'red'}; font-weight: bold;">
                        ${socket.status === 1 ? 'Active' : 'Inactive'}
                    </td>
                    <td>
                        <button onclick="toggleSocketStatus(${socket.socket_id})" 
                                class="btn btn-toggle"
                                style="background-color: ${socket.status === 1 ? '#dc3545' : '#28a745'}; color: white;">
                            ${socket.status === 1 ? 'Deactivate' : 'Activate'}
                        </button>
                    </td>
                </tr>
            `).join('') : '';

            Swal.fire({
                title: `Details for ${device.model || 'N/A'}`,
                html: `
                    <div style="font-family: Arial, sans-serif;">
                        <h5>Device Information</h5>
                        <p><strong>Model:</strong> ${device.model || 'N/A'}</p>
                        <p><strong>Version:</strong> ${device.version || 'N/A'}</p>
                        <p><strong>Number of Wired Ports:</strong> ${device.number_of_wired_port || 'N/A'}</p>
                        <p><strong>Number of Wireless Ports:</strong> ${device.number_of_wireless_port || 'N/A'}</p>
                        <p><strong>IP Address:</strong> ${device.ip_addrees  || 'N/A'}</p>
                        <p><strong>Status:</strong> ${device.status === 'active' ? 'Active' : 'Inactive'}</p>
                        <p><strong>Created At:</strong> ${device.created_at || 'N/A'}</p>
                        <p><strong>Updated At:</strong> ${device.updated_at || 'N/A'}</p>

                        <h5>Client Details</h5>
                        <p><strong>Client Name:</strong> ${client ? client.name || 'N/A' : 'N/A'}</p>
                        <p><strong>Client Phone:</strong> ${client ? client.phone_number || 'N/A' : 'N/A'}</p>
                        <p><strong>Client Address:</strong> ${client ? client.home_address || 'N/A' : 'N/A'}</p>
                        <p><strong>Solar System Name:</strong> ${client ? client["Solar System Name"] || 'N/A' : 'N/A'}</p>

                        <h5>Sockets</h5>
                        <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
                            <thead>
                                <tr style="background-color: #f2f2f2;">
                                    <th style="border: 1px solid #ddd; padding: 8px;">Socket ID</th>
                                    <th style="border: 1px solid #ddd; padding: 8px;">Model</th>
                                    <th style="border: 1px solid #ddd; padding: 8px;">Version</th>
                                    <th style="border: 1px solid #ddd; padding: 8px;">Name</th>
                                    <th style="border: 1px solid #ddd; padding: 8px;">Connection Type</th>
                                    <th style="border: 1px solid #ddd; padding: 8px;">Status</th>
                                    <th style="border: 1px solid #ddd; padding: 8px;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${sockets}
                            </tbody>
                        </table>
                    </div>
                `,
                showCloseButton: true,
                width: '80%',
                confirmButtonText: 'Close'
            });
        } else {
            Swal.fire({
                title: 'Error',
                text: 'An error occurred while retrieving device details.',
                icon: 'error'
            });
        }
    })
    .catch(error => {
        console.log('error', error);
        Swal.fire({
            title: 'Error',
            text: 'An error occurred while retrieving device details.',
            icon: 'error'
        });
    });
}

function toggleSocketStatus(socketId) {
    const token = sessionStorage.getItem('token'); // الحصول على التوكن
    fetch(`https://volta.sy/api/Dash/ChangeSocketStatus?socket_id=${socketId}`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Socket status has been updated successfully") {
            Swal.fire({
                title: 'Success',
                text: 'Socket status has been updated successfully.',
                icon: 'success'
            }).then(() => {
                // إعادة تحميل التفاصيل بعد التحديث
                showDeviceBroadcastDetails(deviceId);
            });
        } else {
            Swal.fire({
                title: 'Error',
                text: 'An error occurred while updating the socket status.',
                icon: 'error'
            });
        }
    })
    .catch(error => {
        console.log('error', error);
        Swal.fire({
            title: 'Error',
            text: 'An error occurred while updating the socket status.',
            icon: 'error'
        });
    });
}

function toggleSocketStatus(socketId) {
    const token = sessionStorage.getItem('token'); // الحصول على التوكن
    fetch(`https://volta.sy/api/Dash/ChangeSocketStatus?socket_id=${socketId}`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Socket status has been updated successfully") {
            Swal.fire({
                title: 'Success',
                text: 'Socket status has been updated successfully.',
                icon: 'success'
            }).then(() => {
                // إعادة تحميل التفاصيل بعد التحديث
                showDeviceBroadcastDetails(deviceId);
            });
        } else {
            Swal.fire({
                title: 'Error',
                text: 'An error occurred while updating the socket status.',
                icon: 'error'
            });
        }
    })
    .catch(error => {
        console.log('error', error);
        Swal.fire({
            title: 'Error',
            text: 'An error occurred while updating the socket status.',
            icon: 'error'
        });
    });
}



const addBroadcastDeviceBtn = document.getElementById('add-broadcast-device-btn');
if (addBroadcastDeviceBtn) {
    addBroadcastDeviceBtn.addEventListener('click', addBroadcastDevice);
}

function addBroadcastDevice() {
    Swal.fire({
        title: 'Add Broadcast Device',
        html: `
            <input id="model" class="swal2-input" placeholder="Model">
            <input id="version" class="swal2-input" placeholder="Version">
            <input id="number_of_wired_port" class="swal2-input" type="number" placeholder="Number of Wired Ports">
            <input id="number_of_wireless_port" class="swal2-input" type="number" placeholder="Number of Wireless Ports">
            <input id="ip_address" class="swal2-input" placeholder="IP Address">
            <div id="sockets-container">
                <!-- نموذج إدخال للمقابس -->
                <div class="socket-entry">
                    <input class="swal2-input" placeholder="Socket Model" data-field="socket_model">
                    <input class="swal2-input" placeholder="Socket Version" data-field="socket_version">
                    <input class="swal2-input" placeholder="Serial Number" data-field="serial_number">
                    <input class="swal2-input" placeholder="Socket Name" data-field="socket_name">
                    <input class="swal2-input" placeholder="Connection Type" data-field="socket_connection_type">
                </div>
            </div>
            <button id="add-socket-btn" class="swal2-confirm swal2-styled">Add More Sockets</button>
        `,
        confirmButtonText: 'Add Device',
        cancelButtonText: 'Cancel',
        showCancelButton: true,
        preConfirm: () => {
            const model = Swal.getPopup().querySelector('#model').value;
            const version = Swal.getPopup().querySelector('#version').value;
            const number_of_wired_port = Swal.getPopup().querySelector('#number_of_wired_port').value;
            const number_of_wireless_port = Swal.getPopup().querySelector('#number_of_wireless_port').value;
            const ip_address = Swal.getPopup().querySelector('#ip_address').value;

            const socketEntries = document.querySelectorAll('.socket-entry');
            const sockets = Array.from(socketEntries).map(entry => {
                const fields = entry.querySelectorAll('input');
                return Array.from(fields).reduce((acc, field) => {
                    acc[field.dataset.field] = field.value;
                    return acc;
                }, {});
            });

            return { model, version, number_of_wired_port, number_of_wireless_port, ip_address, sockets };
        },
        didOpen: () => {
            document.getElementById('add-socket-btn')?.addEventListener('click', function () {
                const newSocketEntry = document.createElement('div');
                newSocketEntry.classList.add('socket-entry');
                newSocketEntry.innerHTML = `
                    <input class="swal2-input" placeholder="Socket Model" data-field="socket_model">
                    <input class="swal2-input" placeholder="Socket Version" data-field="socket_version">
                    <input class="swal2-input" placeholder="Serial Number" data-field="serial_number">
                    <input class="swal2-input" placeholder="Socket Name" data-field="socket_name">
                    <input class="swal2-input" placeholder="Connection Type" data-field="socket_connection_type">
                `;
                document.getElementById('sockets-container').appendChild(newSocketEntry);
            });
        }
    }).then(result => {
        if (result.isConfirmed) {
            const { model, version, number_of_wired_port, number_of_wireless_port, ip_address, sockets } = result.value;
            fetch("https://volta.sy/api/Dash/AddBroadcastDeviceData", {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    model,
                    version,
                    number_of_wired_port,
                    number_of_wireless_port,
                    ip_address,
                    sockets
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.msg === "Broadcast device and sockets added successfully") {
                    Swal.fire({
                        title: 'Success',
                        text: 'Broadcast device and sockets added successfully.',
                        icon: 'success'
                    });
                    fetchBroadcastDevices(); // تحديث القائمة بعد إضافة الجهاز
                } else {
                    Swal.fire({
                        title: 'Error',
                        text: 'Failed to add broadcast device and sockets. Please check the input fields.',
                        icon: 'error'
                    });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    title: 'Error',
                    text: 'Failed to add broadcast device and sockets.',
                    icon: 'error'
                });
            });
        }
    });
}


fetchBroadcastDevices();
// 


function addCenterText(chart, value) {
    const ctx = chart.ctx;
    const width = chart.width;
    const height = chart.height;
    const text = value;
    ctx.restore();
    ctx.font = "bold 20px Arial";
    ctx.textBaseline = "middle";
  
    const textX = Math.round((width - ctx.measureText(text).width) / 2);
    const textY = height / 2;
  
    ctx.fillText(text, textX, textY);
    ctx.save();
  }
  
  fetch('https://volta.sy/api/Dash/getDashboardData', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    }
  })
    .then(response => response.json())
    .then(data => {
      const dashboardData = data["Home Page Data"];
  
      createDoughnutChart('batteryChart', 'Battery Count', dashboardData.battery_count, '#FF6384');
      createDoughnutChart('inverterChart', 'Inverter Count', dashboardData.inverter_count, '#36A2EB');
      createDoughnutChart('panelChart', 'Panel Count', dashboardData.panel_count, '#FFCE56');
      createDoughnutChart('clientChart', 'Client Count', dashboardData.client_count, '#4BC0C0');
      createDoughnutChart('technicalExpertChart', 'Technical Expert Count', dashboardData.technical_expert_count, '#9966FF');
      createDoughnutChart('requestEquipmentChart', 'Request Equipment Count', dashboardData.request_equipment_count, '#FF9F40');
      createDoughnutChart('broadcastDeviceChart', 'Broadcast Device Count', dashboardData.broadcast_device_count, '#FF6384');
      createDoughnutChart('solarSystemChart', 'Solar System Count', dashboardData.solar_system_count, '#36A2EB');
    })
    .catch(error => console.error('Error fetching data:', error));
  
  // دالة لإنشاء رسم بياني دائري
  function addCenterText(chart, value) {
    const ctx = chart.ctx;
    const width = chart.width;
    const height = chart.height;
    const text = value;
    ctx.restore();
    ctx.font = "bold 20px Arial";
    ctx.textBaseline = "middle";

    const textX = Math.round((width - ctx.measureText(text).width) / 2);
    const textY = height / 2;

    ctx.fillText(text, textX, textY);
    ctx.save();
}

function fetchDashboardData() {
    fetch('https://volta.sy/api/Dash/getDashboardData', {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        const dashboardData = data["Home Page Data"];

        createDoughnutChart('batteryChart', 'Battery Count', dashboardData.battery_count, '#FF6384');
        createDoughnutChart('inverterChart', 'Inverter Count', dashboardData.inverter_count, '#36A2EB');
        createDoughnutChart('panelChart', 'Panel Count', dashboardData.panel_count, '#FFCE56');
        createDoughnutChart('clientChart', 'Client Count', dashboardData.client_count, '#4BC0C0');
        createDoughnutChart('technicalExpertChart', 'Technical Expert Count', dashboardData.technical_expert_count, '#9966FF');
        createDoughnutChart('requestEquipmentChart', 'Request Equipment Count', dashboardData.request_equipment_count, '#FF9F40');
        createDoughnutChart('broadcastDeviceChart', 'Broadcast Device Count', dashboardData.broadcast_device_count, '#FF6384');
        createDoughnutChart('solarSystemChart', 'Solar System Count', dashboardData.solar_system_count, '#36A2EB');
    })
    .catch(error => console.error('Error fetching data:', error));
}

function createDoughnutChart(chartId, label, value, color) {
    const total = value + 5; 
    const ctx = document.getElementById(chartId).getContext('2d');
    
    if (ctx.chart) {
        ctx.chart.destroy();
    }
    
    const chart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: [label],
            datasets: [{
                label: label,
                data: [value, total - value], 
                backgroundColor: [color, '#f0f2f5'] 
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, 
            cutout: '70%',
            plugins: {
                legend: {
                    display: false
                }
            }
        },
        plugins: [{
            beforeDraw: function (chart) {
                addCenterText(chart, value);
            }
        }]
    });
}

fetchDashboardData(); 
setInterval(fetchDashboardData, 15000); 

  
if (!sessionStorage.getItem('token')) {
    window.location.href = 'login.html';    
}
