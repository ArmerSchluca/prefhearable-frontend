# Prefhearable

> **Prefhearable** is a mobile data collection instrument developed to standardize the assessment of personal **hearing preferences** based on psychoacoustic and contextual data with special focus on health-related wellbeeing. 

This app serves as a large-scale crowdsourcing tool to build a comprehensive, standardized dataset for audiology and hearing research. The long-term goal of this dataset is to enable advanced **Auditory Profiling** using Machine Learning.

This repository contains the source code for the mobile application developed as part of a Bachelor's Thesis: 
*"Entwicklung eines mobilen Erhebungsinstruments zur standardisierten Erfassung persönlicher Hörpräferenzen auf Basis psychoakustischer und kontextueller Daten"*.

---

## Purpose & Scope

⚠️ **Note:** *Prefhearable is strictly a data collection and crowdsourcing tool. It does not perform data analysis or machine learning evaluation on the device.*

To train robust machine learning models for auditory profiling, researchers require a vast amount of diverse data. This app bridges the gap between lab research and the real world by allowing users to contribute data seamlessly via their smartphones.

### Key Features of the App:
* **Psychoacoustic Testing:** Seamless, user-friendly mobile audio tests to capture hearing characteristics.
* **Contextual Data Harvesting:** Gathering situational data (e.g., environmental noise levels, user activity, or time of day) to understand *where* and *how* people listen.
* **Standardized Dataset Creation:** Consolidating user inputs into a structured format ready for future big data and AI analysis.

---

## Tech Stack & Architecture

* **Frontend:** Flutter (Dart)
* **Target Platforms:** iOS & Android
* **Other theoretically supported Platforms:** Windows & macOS (not tested)

## Getting Started (Client)

### Prerequisites
Before running the app, ensure you have the [Flutter SDK](https://docs.flutter.dev/install/quick) installed on your machine.

### Installation & Run

1. Clone this repository:
```bash
   git clone https://git.rchw.de/Prefhearable/frontend.git
```