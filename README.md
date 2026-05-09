# Electroacoustics-DSP-Projects
MATLAB projects for Electroacoustics and Audio Signal Processing course
# Audio Signal Processing Projects for Electroacoustics

This repository contains MATLAB mini-projects developed for undergraduate students in Electroacoustics and Audio Signal Processing courses.

The projects are designed to bridge theoretical concepts and practical DSP implementations in speech and audio processing.

Main topics include:

- Acoustic Echo Cancellation (AEC)
- Adaptive Filtering (NLMS)
- Room Impulse Response (RIR)
- Convolution Reverb
- Audio Equalization (EQ)
- Spectrogram Analysis
- Speech Processing
- Pitch and Timbre Analysis

The projects aim to help students understand how acoustic systems can be modeled as signal processing systems using MATLAB.
---

# Project 1: Acoustic Echo Cancellation Using Adaptive Filters

## Objective

The objective of this project is to remove acoustic echo caused by multipath propagation and room reflections using adaptive filtering techniques.

## Concept

The room acoustic path is modeled as an unknown system.

A far-end speech signal is applied to:

- the unknown acoustic path
- an adaptive filter (NLMS)

The adaptive filter continuously updates its coefficients to estimate the echo path.

Once the adaptive filter converges toward the room response, the estimated echo is subtracted from the microphone signal to recover the near-end speech.

## DSP Concepts

- Adaptive Filtering
- NLMS Algorithm
- System Identification
- Acoustic Echo Cancellation
- Room Impulse Response
- Mean Square Error Minimization

## MATLAB Files

- partA.m`&B&C&D
- `room.mat`
- `css.mat`
- ---

# Project 2: Room Simulation and Audio Processing

## Objective

This project demonstrates how room acoustics affect speech signals using convolution reverb and equalization techniques.

Students record speech using MATLAB, then simulate acoustic environments by applying a room impulse response.

The project also demonstrates:

- Reverberation
- Equalization (EQ)
- Spectrogram analysis
- Pitch removal (whisper effect)

## Concept

The room is modeled as a linear time-invariant system characterized by its impulse response.

Reverberation is added using convolution:

y(n) = x(n) * h(n)

where:

- x(n): dry speech signal
- h(n): room impulse response
- y(n): reverberated signal

The equalizer modifies the spectral content of speech, while reverb modifies its temporal structure.

## DSP Concepts

- Convolution
- Room Impulse Response
- Reverb
- Spectrogram
- Power Spectral Density (PSD)
- Audio Equalization
- LPC Analysis
- Pitch Removal

## MATLAB Files

- `reverb_equalizer.m`
- `room.mat`
- 
