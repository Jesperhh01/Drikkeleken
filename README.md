# 🎃 Drikkeleken - Halloween Edition 🎃

A fun Norwegian drinking game web application with a Halloween theme, perfect for parties!

## 🌟 Features

- 🎲 Random challenge generator
- 📝 Add your own custom challenges
- 👻 Surprise troll images (30% chance with guaranteed appearance every 10 clicks)
- 🎨 Professional Halloween-themed UI with floating emojis
- 📱 Fully responsive design
- ⚡ Fast and lightweight

## 🚀 Quick Start

### Local Development

1. **Clone and setup**
   ```bash
   git clone <your-repo-url>
   cd Drikkeleken
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the application**
   ```bash
   python main.py
   ```

4. **Open in browser**
   ```
   http://localhost:5000
   ```

## ☁️ AWS Deployment

**All deployment resources are organized in the `deployment/` folder!**

### Quick Deploy

```bash
cd deployment/aws-eb
./deploy.sh
```

### Custom Domain Setup

```bash
cd deployment/aws-eb
./setup-custom-domain.sh
```

### Documentation

- **[deployment/README.md](deployment/README.md)** - Complete deployment guide
- **[Quick Start](deployment/docs/AWS_QUICKSTART.md)** - Fast deployment
- **[Domain Setup](deployment/docs/SIMPLE_DOMAIN_SETUP.md)** - Custom domain (no CLI)

**Your Live App**: http://drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com

### Manual Deployment

See detailed guides:
- [Quick Start Guide](./AWS_QUICKSTART.md)
- [Full Deployment Guide](./EB_DEPLOYMENT.md)
- [Setup Summary](./EB_SETUP_SUMMARY.md)

## 📁 Project Structure

```
Drikkeleken/
├── app/
│   ├── __init__.py          # Flask app factory
│   ├── routes/
│   │   └── main.py          # Application routes
│   ├── services/
│   │   ├── question_manager.py   # Question/challenge management
│   │   └── troll_manager.py      # Troll image management
│   ├── static/
│   │   ├── css/
│   │   │   └── site.css     # Main stylesheet
│   │   ├── js/
│   │   └── img/
│   └── templates/
│       ├── index.html       # Landing page
│       ├── questions.html   # Add challenges page
│       └── challenges.html  # Display challenges page
├── application.py           # EB entry point
├── main.py                  # Local dev entry point
├── config.py                # Configuration
├── requirements.txt         # All dependencies
├── requirements-production.txt  # Production dependencies
└── .ebextensions/           # EB configuration
```

## 🎮 How to Play

1. **Start the Game**: Click "START SPILLET" on the home page
2. **Get Challenges**: Click "NY UTFORDRING" to get random challenges
3. **Add Custom Challenges**: Click "BLI MED I SPILL" to add your own
4. **Surprise Images**: Random images appear with challenges (30% chance)
5. **Follow Instructions**: Complete the challenges shown!

## 🛠️ Technology Stack

- **Backend**: Flask 3.0
- **Frontend**: Bootstrap 5.3, Custom CSS
- **Fonts**: Google Fonts (Montserrat, Inter)
- **Deployment**: AWS Elastic Beanstalk
- **Server**: Gunicorn (production)

## 📝 Environment Variables

Optional configuration:
- `SECRET_KEY` - Flask secret key (auto-generated if not set)
- `FLASK_ENV` - Environment (development/production)
- `DATABASE_URL` - Database connection (if using DB in future)

## 🔧 Development

### Running Tests
```bash
# Add your test command here when tests are implemented
pytest
```

### Code Style
```bash
# Format code
black .

# Lint
flake8 app/
```

## 📦 Dependencies

Main dependencies:
- Flask 3.0.0
- Gunicorn 23.0.0
- Bootstrap 5.3.3 (CDN)

See `requirements.txt` for full list.

## 🚢 Deployment Scripts

- `./deploy.sh` - Interactive deployment helper
- `./check-deployment.sh` - Pre-deployment verification

## 📚 Documentation

- [AWS Quick Start](./AWS_QUICKSTART.md) - Fast deployment guide
- [EB Deployment Guide](./EB_DEPLOYMENT.md) - Detailed deployment steps
- [Setup Summary](./EB_SETUP_SUMMARY.md) - Configuration overview

## 🎨 Customization

### Adding Troll Images

Edit `app/services/troll_manager.py`:
```python
troll_images = [
    'https://your-image-url.com/image1.jpg',
    'https://your-image-url.com/image2.jpg',
    # Add more images...
]
```

### Changing Challenge Probability

Edit `app/templates/challenges.html`:
```javascript
// Change from 0.3 (30%) to your desired probability
if (randomValue < 0.3) {
    showTrollImage();
}
```

### Styling

Edit `app/static/css/site.css` to customize colors, fonts, and animations.

## 🐛 Troubleshooting

### Local Development

**Port already in use:**
```bash
# Change port in main.py or:
flask run --port 8000
```

**Module not found:**
```bash
pip install -r requirements.txt
```

### AWS Deployment

**Check logs:**
```bash
eb logs
```

**SSH into instance:**
```bash
eb ssh
tail -f /var/log/eb-engine.log
```

**Health check failing:**
Visit `https://your-app.elasticbeanstalk.com/health`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available for personal and educational use.

## 🎉 Credits

Created with ❤️ for Halloween party fun!

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review the deployment guides
3. Check AWS EB documentation

---

**Have fun and drink responsibly! 🍻🎃👻**

