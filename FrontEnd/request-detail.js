window.onload = function() {
    const urlParams = new URLSearchParams(window.location.search);
    const requestId = urlParams.get('requestId');

    if (!requestId) {
        document.getElementById('request-details-container').innerHTML = '<p>No request found.</p>';
        return;
    }

    const token = sessionStorage.getItem('token');

    if (!token) {
        Swal.fire({
            icon: 'error',
            title: 'No token found',
            text: 'Please log in to continue.'
        });
        return;
    }

    // Fetch request details based on requestId
    fetch("https://volta.sy/api/Dash/ShowAllRequestEquipment", {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ request_equipment_id: requestId })
    })
    .then(response => response.json())
    .then(data => {
        if (data.msg === "Successfully ") {
            const request = data["All Equipment Request"].find(r => r.request_equipment_id == requestId);

            if (request) {
                const detailsContainer = document.getElementById('request-details-container');
                detailsContainer.innerHTML = `
                    <p><strong>Name:</strong> ${request.name || 'N/A'}</p>
                    <p><strong>Technical Expert Name:</strong> ${request.technical_expert?.name || 'N/A'}</p>
                    <p><strong>Number of Panels:</strong> ${request.number_of_panel || 'N/A'}</p>
                    <p><strong>Number of Batteries:</strong> ${request.number_of_battery || 'N/A'}</p>
                    <p><strong>Number of Inverters:</strong> ${request.number_of_inverter || 'N/A'}</p>
                    <p><strong>Additional Equipment:</strong> ${request.additional_equipment || 'N/A'}</p>
                    <p><strong>Status:</strong> ${request.status || 'N/A'}</p>
                    <p><strong>Comments:</strong> ${request.commet || 'N/A'}</p>
                    <p><strong>Created At:</strong> ${request.created_at ? formatDate(request.created_at) : 'N/A'}</p>
                `;

                // Fetch panel, battery, and inverter details using their IDs
                if (request.panel_id) {
                    fetchDetails('panel', request.panel_id);
                }

                if (request.battery_id) {
                    fetchDetails('battery', request.battery_id);
                }

                if (request.inverters_id) {
                    fetchDetails('inverter', request.inverters_id);
                }

            } else {
                Swal.fire({
                    icon: 'info',
                    title: 'Request Details',
                    text: 'Request details could not be found.'
                });
            }
        } else {
            Swal.fire({
                icon: 'info',
                title: 'Request Details',
                text: 'Details could not be fetched.'
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to fetch request details. Please try again.'
        });
    });
};

// Format date to a readable format
function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('en-GB');
}

// Fetch and display the details for panel, battery, or inverter
function fetchDetails(type, id) {
    const token = sessionStorage.getItem('token');

    if (!id || id === 'N/A') {
        return; // No details available for this item
    }

    let apiUrl;
    switch (type) {
        case 'panel':
            apiUrl = 'https://volta.sy/api/Dash/ShowAllPanel';
            break;
        case 'battery':
            apiUrl = 'https://volta.sy/api/Dash/ShowAllBattery';
            break;
        case 'inverter':
            apiUrl = 'https://volta.sy/api/Dash/ShowAllInverter';
            break;
        default:
            console.error(`Unknown type: ${type}`);
            return;
    }

    fetch(apiUrl, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        let details = null;

        switch (type) {
            case 'panel':
                details = data["All Panel"].find(panel => panel.panel_id == id);
                break;
            case 'battery':
                details = data["All Battery"].find(battery => battery.battery_id == id);
                break;
            case 'inverter':
                details = data["All Inverter"].find(inverter => inverter.inverters_id == id);
                break;
        }

        if (details) {
            const detailsContainer = document.getElementById('equipment-details-container');
            detailsContainer.innerHTML += `
                <div class="card">
                    <h3>${type.charAt(0).toUpperCase() + type.slice(1)} Details</h3>
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
                </div>
            `;
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
}

document.getElementById('approve-btn').onclick = function() {
    const requestId = new URLSearchParams(window.location.search).get('requestId');
    const token = sessionStorage.getItem('token');
    const comment = 'تم الموافقة على الطلب وسوف يتم شحنه اليك';

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
                title: 'Success',
                text: 'تم الموافقة على الطلب.'
            });
        } else if (data.msg === "This request has already been approved.") {
            Swal.fire({
                icon: 'info',
                title: 'Info',
                text: 'This request has already been approved.'
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Error',
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
};

document.getElementById('reject-btn').onclick = function() {
    const requestId = new URLSearchParams(window.location.search).get('requestId');
    const token = sessionStorage.getItem('token');

    // Using SweetAlert2 to get rejection comment
    Swal.fire({
        title: 'Rejection Comment',
        input: 'textarea',
        inputPlaceholder: 'Please enter your comments for rejection...',
        showCancelButton: true,
        confirmButtonText: 'Submit',
        cancelButtonText: 'Cancel',
        preConfirm: (comment) => {
            if (!comment) {
                Swal.showValidationMessage('Comment is required');
            }
            return comment;
        }
    }).then((result) => {
        if (result.isConfirmed) {
            const comment = result.value;

            fetch(`https://volta.sy/api/Dash/rejected`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ request_equipment_id: requestId, commet: comment })
            })
            .then(response => response.json())
            .then(data => {
                if (data.msg === "Successfully status update") {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: 'تم رفض الطلب.'
                    });
                } else if (data.msg === "This request has already been rejected.") {
                    Swal.fire({
                        icon: 'info',
                        title: 'Info',
                        text: 'This request has already been rejected.'
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
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
};

