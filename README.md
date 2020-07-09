# react-native-azure-blob-storage

## Getting started

`$ npm install react-native-azure-blob-storage --save`

### Mostly automatic installation

`$ react-native link react-native-azure-blob-storage`

## Usage
```javascript
import React, { Component } from 'react';
import { Button, StyleSheet, ScrollView, View, Image, TouchableOpacity, Platform } from 'react-native';
import { EAzureBlobStorageImage } from 'react-native-azure-blob-storage';
import CameraRoll from "@react-native-community/cameraroll";

 class App extends Component {
  state = {
    photos: []
  }
  async componentDidMount() {
    EAzureBlobStorageImage.configure(
      "Account Name", //Account Name
      "Account Key", //Account Key
      "images" //Container Name
    );
  }
  _handleButtonPress = () => {
    CameraRoll.getPhotos({
      first: 20,
      assetType: 'Photos',
    })
      .then(r => {
        this.setState({ photos: r.edges });
      })
      .catch((err) => {
        console.log("Errror", err)
      });
  };
  render() {
    return (
      <View>
        <Button title="Load Images" onPress={this._handleButtonPress} />
        <ScrollView>
          {this.state.photos.map((p, i) => {
            return (
              <TouchableOpacity
                onPress={ () => {
                   EAzureBlobStorageFile.uploadFile({
                              "filePath":Platform.OS === 'android'?filePath:'file://' + filePath,
                              "contentType":"audio/wav",
                              "fileName":"test.wav"
                            }).then((name) => {  
                              console.log('File Name  ' + name);  
                            }).catch((error) => {  
                                console.log('Error' + error); 
                            }); 
                }}
              >
                <Image
                  key={i}
                  style={{
                    width: 300,
                    height: 100,
                  }}
                  source={{ uri: p.node.image.uri }}
                />
              </TouchableOpacity>
            );
          })}
        </ScrollView>
      </View>
    );
  }
}

```
## Example
```
Ios requires a relative path Android Will work with either 
EAzureBlobStorageImage.uploadFile('/Route To Image.PNG'')

```


