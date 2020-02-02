# react-native-azure-blob-storage

## Getting started

`$ npm install react-native-azure-blob-storage --save`

### Mostly automatic installation

`$ react-native link react-native-azure-blob-storage`

## Usage
```javascript
import React, { Component } from 'react';
import { Button, StyleSheet, ScrollView, View, Image, TouchableOpacity } from 'react-native';
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
                onPress={async () => {
                  var name = await EAzureBlobStorageImage.uploadFile(p.node.image.uri)
                  console.log("Container File Name", name)
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
## Example Usage IOS
```
Ios requires a relative path
EAzureBlobStorageImage.uploadFile('/private/var/mobile/Containers/Data/Application/F59ABE10-8F33-4E96-97FA-6D186C91E45A/tmp/086B8A32-673A-4198-973F-DB3B3F114448-2024-00000E06291EB53C/IMG_0025.PNG'')

```
## Example Usage Android
```
Android requires an absolute path
EAzureBlobStorageImage.uploadFile('file:///private/var/mobile/Containers/Data/Application/F59ABE10-8F33-4E96-97FA-6D186C91E45A/tmp/086B8A32-673A-4198-973F-DB3B3F114448-2024-00000E06291EB53C/IMG_0025.PNG'')

```

