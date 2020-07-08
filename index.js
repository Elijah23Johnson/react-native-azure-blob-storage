import { requireNativeComponent, NativeModules } from 'react-native';

const EAzureBlobStorage = requireNativeComponent('EAzureBlobStorage', null);
const EAzureBlobStorageFile = NativeModules.EAzureBlobStorageFile

export { 
    EAzureBlobStorageFile 
};

export default EAzureBlobStorage;
