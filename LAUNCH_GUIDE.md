# 🚀 Iron Front: Launch Guide (Non-Developer Edition)

This guide is for someone who **doesn't code** and wants to get this game on Google Play Store.

---

## 🎯 The Realistic Path

You have **3 options** to get this on the Play Store:

### Option A — Hire a Flutter developer (RECOMMENDED for non-coders)
**Cost**: $500 – $3,000 USD (one-time)  
**Time**: 1–4 weeks  
**Risk**: Lowest

What to do:
1. Go to **Fiverr.com** or **Upwork.com**
2. Search: "Flutter game developer with AdMob and Play Store experience"
3. Send them this entire project folder
4. Ask them to:
   - Set up Firebase, Supabase, AdMob, Play Billing accounts (using your credentials)
   - Replace placeholder keys
   - Test on real Android devices
   - Help you publish to Play Store
   - Add real artwork (or use placeholder)
5. **Budget**: Get 3-5 quotes. Average for this scope: $800-$1500.

### Option B — Learn Flutter yourself (free, slow)
**Cost**: $25 (Play Console) + free time  
**Time**: 3–6 months of learning  
**Risk**: High (most beginners give up)

Learning path:
1. Free Flutter course: https://www.youtube.com/watch?v=VPvVD8t02U8
2. Dart language basics: https://dart.dev/tutorials
3. Flame engine docs: https://docs.flame-engine.org/

### Option C — Find a developer co-founder (50/50 split)
**Cost**: $25 (Play Console only)  
**Time**: 1-2 months  
**Risk**: Medium

Where to find:
- Reddit: r/flutterdev, r/gamedev, r/cofounder
- Indie Hackers: https://www.indiehackers.com/
- Discord: Flutter Community, GameDev servers

---

## 💵 Real Earnings Expectations (Honest Numbers)

I will not lie to you about this:

| Stage | Realistic Monthly Earnings |
|---|---|
| Week 1 after launch | $0 – $2 |
| Month 1 | $0 – $20 |
| Month 3 (with some marketing) | $0 – $100 |
| Month 6 (with luck + updates) | $0 – $500 |
| Year 1 (if you put in real work) | $0 – $5,000 |

**Brutal truth**: 99% of new mobile games earn under $50/month forever. Success requires:
1. **Marketing budget** ($500-$5000+ on TikTok/Instagram ads)
2. **Constant updates** (1-2 per month with new content)
3. **Player retention features** (daily rewards, events, social)
4. **Luck** (going viral)

---

## 📋 Pre-Launch Checklist

Before submitting to Play Store, verify:

- [ ] Replaced all `REPLACE_ME` values in `lib/config/app_config.dart`
- [ ] Replaced AdMob test IDs with real ones in `AppConfig` and `AndroidManifest.xml`
- [ ] Created google-services.json from Firebase, placed in `android/app/`
- [ ] Ran `supabase/schema.sql` in Supabase SQL editor
- [ ] Created all 6 IAP/subscription products in Play Console
- [ ] Generated release keystore (and backed it up in 3+ places!)
- [ ] Built signed AAB: `flutter build appbundle --release`
- [ ] Tested AAB on a real Android phone via internal testing track
- [ ] Created store listing (icon, screenshots, feature graphic, description)
- [ ] Wrote a Privacy Policy (you can use https://app-privacy-policy-generator.firebaseapp.com/)
- [ ] Hosted Privacy Policy on a public URL (GitHub Pages is free)
- [ ] Completed data safety form in Play Console
- [ ] Completed content rating questionnaire
- [ ] Set country pricing

---

## 🎨 What You Still Need to Provide

The current code uses **geometric shapes for enemies/towers**. To make it look professional, you need:

### Free art sources:
- **OpenGameArt.org** — Free 2D sprites (check license)
- **Kenney.nl** — Free game assets (CC0 license, commercial use OK)
- **Itch.io free assets** — Search "tower defense assets"

### Paid (small budget):
- **GameDev Market**: $5-$30 for full tower defense packs
- **Unity Asset Store**: $10-$50 for sprite packs
- **Hire a 2D artist on Fiverr**: $50-$300

### Music/SFX (free):
- **freesound.org** — Free CC sounds
- **OpenGameArt audio section**

---

## ⚖️ Legal Stuff (Don't Skip)

1. **Privacy Policy** — REQUIRED by Play Store, AdMob, and Google Sign-In. Generate one for free: https://app-privacy-policy-generator.firebaseapp.com/
2. **Terms of Service** — Recommended. Same generator above.
3. **GDPR Consent** — If you target EU users, you need AdMob's UMP SDK consent flow.
4. **COPPA** — If targeting kids under 13, special rules apply (no personalized ads).

---

## 🤝 Hiring a Developer? Here's What to Say

Copy-paste this to a Fiverr/Upwork developer:

> Hi! I have a complete Flutter tower defense game project (Iron Front: Last Defense) that needs to be finished and published to Google Play Store. The code is ready — I need someone to:
> 
> 1. Set up Firebase, Supabase, and AdMob accounts (I'll provide my credentials)
> 2. Replace placeholder API keys in the config file
> 3. Test the app on real Android devices
> 4. Build a signed release AAB
> 5. Help me upload to Play Console and complete store listing
> 6. (Optional) Replace placeholder geometric art with real sprites
> 
> Tech stack: Flutter + Flame engine + Supabase + AdMob + Google Play Billing
> 
> Budget: $___ (start at $500-800)
> 
> Can you send me your portfolio of published Flutter games?

---

## 📞 Need Help?

- Flutter community: https://flutter.dev/community
- r/FlutterDev on Reddit
- Stack Overflow tag: `flutter`

Good luck, commander! 🛡️
