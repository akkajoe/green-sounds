# Green Sounds

**ART 221Y Major Project**

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)

## Introduction

Green Sounds is an interactive art project developed for the ART 221Y course. The project aims to explore the relationship between sound and visual art by creating an immersive audio-visual experience. Using various sensors and visual elements, Green Sounds reacts to environmental inputs to produce unique soundscapes and visual patterns.

## Features

- **Interactive Soundscapes**: Real-time audio generation based on user interaction.
- **Visual Art Integration**: Dynamic visual elements that respond to sound and user inputs.
- **Sensor Inputs**: Utilizes various sensors to capture environmental data.
- **Customizable**: Easily customizable to fit different environments and use cases.

## Installation

To run the Green Sounds project, follow these steps:

1. **Clone the repository**:
   ```sh
   git clone https://github.com/akkajoe/green-sounds.git
   cd green-sounds
   ```

2. **Install dependencies**:
   Ensure you have Python and pip installed. Then, run:
   ```sh
   pip install -r requirements.txt
   ```

3. **Setup the environment**:
   You may need to configure environment variables or install additional software depending on the sensors and hardware you are using.

## Usage

1. **Run the project**:
   ```sh
   python main.py
   ```

2. **Interacting with the installation**:
   Follow the instructions provided in the interface to interact with the different features of the project.

## Directory Structure

```
green-sounds/
├── data/                    # Directory for datasets and input files
├── sensors/                 # Sensor integration and data collection scripts
├── visuals/                 # Visual components and processing scripts
├── audio/                   # Audio processing and generation scripts
├── main.py                  # Main entry point for the project
├── requirements.txt         # List of required libraries
└── README.md                # Readme file
```

## Contributing

We welcome contributions to the Green Sounds project. If you have any ideas, suggestions, or improvements, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.
