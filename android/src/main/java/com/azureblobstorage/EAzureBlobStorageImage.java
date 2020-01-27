
package com.azureblobstorage;
import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.uimanager.IllegalViewOperationException;

public class EAzureBlobStorageImage extends ReactContextBaseJavaModule{
    private static final String E_LAYOUT_ERROR = "E_LAYOUT_ERROR";
    private static final String MODULE_NAME = "EAzureBlobStorageImage";

    public EAzureBlobStorageImage(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
    }


    @Override
    public String getName() {
        return MODULE_NAME;
    }

    @ReactMethod
    public void uploadFile(String name, Promise promise){
    try{
        promise.resolve(name);
    }catch(IllegalViewOperationException e){
        promise.reject(E_LAYOUT_ERROR, e);
    }
       
    }
}