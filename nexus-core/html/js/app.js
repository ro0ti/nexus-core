class NexusUI {
    constructor() {
        this.inventoryOpen = false;
        this.phoneOpen = false;
        this.registerEvents();
    }

    registerEvents() {
        window.addEventListener('message', (event) => {
            const data = event.data;
            switch(data.action) {
                case 'showInventory':
                    this.toggleInventory(data.items);
                    break;
                case 'showNotification':
                    this.showNotification(data);
                    break;
                case 'togglePhone':
                    this.togglePhone(data.toggle);
                    break;
            }
        });
    }

    toggleInventory(items) {
        const inventory = document.getElementById('inventory');
        this.inventoryOpen = !this.inventoryOpen;
        
        if (this.inventoryOpen) {
            inventory.classList.remove('hidden');
            this.populateInventory(items);
        } else {
            inventory.classList.add('hidden');
        }
    }

    populateInventory(items) {
        const grid = document.querySelector('.inventory-grid');
        grid.innerHTML = '';
        
        items.forEach(item => {
            const slot = document.createElement('div');
            slot.className = 'inventory-slot';
            slot.innerHTML = `
                <img src="images/${item.name}.png" alt="${item.label}" width="40">
                <span class="item-count">${item.amount}</span>
            `;
            grid.appendChild(slot);
        });
    }

    showNotification(data) {
        const container = document.getElementById('notifications');
        const notification = document.createElement('div');
        notification.className = 'notification';
        notification.style.borderLeftColor = data.color || '#2e86de';
        notification.textContent = data.message;
        
        container.appendChild(notification);
        setTimeout(() => {
            notification.remove();
        }, data.length || 5000);
    }

    togglePhone(state) {
        const phone = document.getElementById('phone');
        this.phoneOpen = state !== undefined ? state : !this.phoneOpen;
        
        if (this.phoneOpen) {
            phone.classList.remove('hidden');
        } else {
            phone.classList.add('hidden');
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    new NexusUI();
});