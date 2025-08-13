# Pixel Foods - Cloud Kitchen Management System

## Project Overview
Pixel Foods is a comprehensive cloud kitchen management system designed to streamline the operations of cloud kitchens. The platform enables kitchen owners to manage their menu, handle orders, track subscriptions, and process payments efficiently.

## Features

### User Management
- Custom user authentication system
- Role-based access control (Admin, Kitchen Staff, Customers)
- User profile management
- Secure password handling

### Menu Management
- Dynamic menu creation and updates
- Category-based organization
- Price management
- Availability tracking
- Image upload for dishes

### Order Management
- Real-time order tracking
- Order status updates
- Order history
- Delivery status tracking

### Subscription System
- Weekly/Monthly meal plans
- Customizable subscription options
- Subscription management
- Auto-renewal functionality

### Payment Integration
- Razorpay payment gateway integration
- Secure payment processing
- Payment history
- Invoice generation

### Admin Dashboard
- Sales analytics
- Order statistics
- User management
- Menu management
- Subscription oversight

## Technical Stack

### Backend
- Django 5.2.3
- Python 3.12
- PostgreSQL Database
- Gunicorn (Production Server)

### Frontend
- HTML5
- CSS3
- JavaScript
- Bootstrap 5
- Crispy Forms

### Additional Technologies
- WhiteNoise (Static File Serving)
- Django Crispy Forms
- Pillow (Image Processing)
- psycopg2 (PostgreSQL Adapter)

## Project Structure
```
pixel_foods/
├── meals/                 # Main application
│   ├── models.py         # Database models
│   ├── views.py          # View logic
│   ├── urls.py           # URL routing
│   └── templates/        # HTML templates
├── users/                # User management app
│   ├── models.py         # User models
│   ├── views.py          # User views
│   └── forms.py          # User forms
├── static/               # Static files
│   ├── css/             # Stylesheets
│   ├── js/              # JavaScript files
│   └── images/          # Image assets
└── templates/            # Base templates
```

## Installation and Setup

1. Clone the repository:
```bash
git clone https://github.com/Mohit-Narayan/ThindiMithra.git
```

2. Create and activate virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate  # Windows
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Set up environment variables:
```bash
DEBUG=False
ALLOWED_HOSTS=.onrender.com
DATABASE_URL=your_postgresql_url
EMAIL_HOST_USER=your_email
EMAIL_HOST_PASSWORD=your_email_password
RAZORPAY_KEY_ID=your_razorpay_key
RAZORPAY_KEY_SECRET=your_razorpay_secret
```

5. Run migrations:
```bash
python manage.py migrate
```

6. Create superuser:
```bash
python manage.py createsuperuser
```

7. Run development server:
```bash
python manage.py runserver
```

## Deployment
The project is deployed on Render.com with the following configuration:
- PostgreSQL database
- Gunicorn as the production server
- WhiteNoise for static file serving
- Environment variables for sensitive data

## Security Features
- CSRF protection
- XSS protection
- Secure password hashing
- SSL/TLS encryption
- Session security
- Input validation

## Future Enhancements
1. Mobile application development
2. Real-time order tracking
3. Advanced analytics dashboard
4. Inventory management system
5. Customer feedback system
6. Integration with delivery services
7. Multi-language support
8. Push notifications

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contact
For any queries or support, please contact:
- Email: mohitnarayanmohit@gmail.com | 
- GitHub: Mohit-narayan | Mahesh-M18 | Athish-Kiran

## Acknowledgments
- Django Documentation
- Bootstrap Documentation
- Render.com Documentation

## Contibuters and Team
- Mohith N | Mahesh M | Athish K R
- -- The Pixel Syyndicate --
