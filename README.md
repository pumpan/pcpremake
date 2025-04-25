# PCPRemake

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![WoW Version](https://img.shields.io/badge/WoW-1.12.1-ff69b4)
![WoW Version](https://img.shields.io/badge/WoW-1.14.2-ff69b4)
![License](https://img.shields.io/badge/license-MIT-green)
<a href="https://www.paypal.com/donate/?hosted_button_id=JCVW2JFJMBPKE" target="_blank">
    <img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" 
         alt="Donate with PayPal" style="border: 0;">
</a>
<a href="https://www.paypal.com/donate/?hosted_button_id=JCVW2JFJMBPKE" class="paypal-button" target="_blank">
    💙 Support Me with PayPal
</a>


## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Changelog](#changelog)

## 📝 Overview

This addon is a remake of the **PartyBot Command Panel (PCP)** for **World of Warcraft (WoW) 1.12.1 and 1.14.2**. It is more customizable than the original addon and introduces new features, including the ability to control bots when you are dead. Additionally, it replaces text-based target markers with sorted icons for a more intuitive experience.

## ✨ Features

- **Resizable Frame:**
  - Resize the frame to better fit your screen by dragging the handle in the bottom-right corner.

- **Themes:**
  - Choose from various themes to customize the panel's appearance.

<p align="center">
  <img src="screens/4.jpg" alt="Preset Selection" width="200">
  <img src="screens/3.jpg" alt="Preset Selection" width="200">
  <img src="screens/2.jpg" alt="Preset Selection" width="200">
  <img src="screens/1.jpg" alt="Preset Selection" width="200">
  <br>
  <em>(Not showing all themes)</em>
</p>

<p align="center">
  <img src="screens/sett.jpg" alt="Settings" width="100">
</p>

- **Backdrop and Title Background:**
  - Choose whether to display a backdrop behind the command panel and a background for the titles (like "Come Commands," "Stay Commands," "Move Commands").
- **New minimap button:**
  <p align="center">
  <img src="screens/minimapbutton.png" alt="Settings" width="100">
</p>

- **Control Bots When Dead:**
  - Maintain control of bots even when your character has died.

- **Reset Frame Position:**
  - Use the command:
    ```
    /movepcp
    ```
    This moves the PCP frame to your cursor, resolving an issue from the original addon where the frame sometimes appeared off-screen.

- **Other Improvements Over the Original Addon:**
  - Icons instead of text for CC marks and focus targets, sorted in the same order as when marking a target.
  - Removed the "Add" button; now you add a bot by clicking the "role button" (e.g., "Tank").
  - Removed the "Add Random" button (it seemed unnecessary to add a random bot).
  - Moved the close button from the bottom to the upper right corner.
  - Changed the minimap button image.
  - Removed everything from the XML file and remade every button and frame in the Lua file, which opened up new possibilities, such as resizing the frame.

## 🛠️ Installation

1. **Download the Addon:**  
   - https://github.com/pumpan/pcpremake/releases/tag/v.1.0.0

2. **Extract Files:**  
   - Extract the contents to your WoW addons directory, typically located at:  
     ```
     World of Warcraft/Interface/AddOns
     ```
   - Rename the folder to `PCP`.

3. **Enable the Addon:**  
   - Launch WoW and go to the AddOns menu from the character selection screen.  
   - Ensure that the addon is enabled in the list.

## 🚀 Usage

1. **Open the PartyBot Command Panel:**  
   - Click the icon on the minimap.

## 📅 Changelog

**PCPRemake 1.1.0**  

    🛠 Improvements: Fixed unpause all button wich wasnt working if you had a target.e.   
**PCPRemake 1.0.0**  

    🆕 **NEW:** First release.





