# react-native-azure-blob-storage

## Getting started

`$ npm install react-native-azure-blob-storage --save`

### Mostly automatic installation

`$ react-native link react-native-azure-blob-storage`

## Usage
```javascript
import EAzureBlobStorage, { EAzureBlobStorageImage } from 'react-native-azure-blob-storage';

  async componentDidMount(){
    var name = await EAzureBlobStorageImage.uploadFile("Naming Some Stuff")
    console.log("This is really cool stuff", name)
  }

```
