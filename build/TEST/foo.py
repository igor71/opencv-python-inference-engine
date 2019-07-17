import cv2
import time
import os
import sys

def getOutputsNames(net):
    # Get the names of all the layers in the network
    layersNames = net.getLayerNames()
    # Get the names of the output layers, i.e. the layers with unconnected outputs
    return [layersNames[i[0] - 1] for i in net.getUnconnectedOutLayers()]

def main():
    start_time = time.time()
    checkpoint_pb = '/media/common/DOWNLOADS/UBUNTU/OpenCV-IE/TEST/graph.pb'
    tensorflowNet = cv2.dnn.readNetFromTensorflow(checkpoint_pb)
    tensorflowNet.setPreferableBackend(cv2.dnn.DNN_BACKEND_INFERENCE_ENGINE)
    tensorflowNet.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)

    picture_path = '/media/common/DOWNLOADS/UBUNTU/OpenCV-IE/TEST/77428.png'
    picture = cv2.imread(picture_path)
    picture = cv2.cvtColor(picture, cv2.COLOR_BGR2GRAY)
    picture = cv2.resize(picture, (640, 360))

    blob = cv2.dnn.blobFromImage(picture, 1 / 255, (640, 360), [0, 0, 0], 1, crop=False)

    # Sets the input to the network
    tensorflowNet.setInput(blob)

    # Runs the forward pass to get output of the output layers
    outs = tensorflowNet.forward()

    print('Success!')
    print(outs)
    # print(f'run time {1000*(time.time() - start_time)} msec')


main()
