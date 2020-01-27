import { requireNativeComponent, NativeModules } from 'react-native';

const EAzureBlobStorage = requireNativeComponent('EAzureBlobStorage', null);
const EAzureBlobStorageImage = NativeModules.EAzureBlobStorageImage

export { 
    EAzureBlobStorageImage 
};

export default EAzureBlobStorage;
