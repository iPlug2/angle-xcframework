#!/bin/zsh

ANGLE_FOLDER=$1
GLESV2_HEADERS_DIR=$2

rsync -av --prune-empty-dirs --include='*/' --include='GLES/*.h' --exclude='*' $ANGLE_FOLDER/include/ $GLESV2_HEADERS_DIR
rsync -av --prune-empty-dirs --include='*/' --include='GLES2/*.h' --exclude='*' $ANGLE_FOLDER/include/ $GLESV2_HEADERS_DIR
rsync -av --prune-empty-dirs --include='*/' --include='GLES3/*.h' --exclude='*' $ANGLE_FOLDER/include/ $GLESV2_HEADERS_DIR
rsync -av --prune-empty-dirs --include='*/' --include='KHR/*.h' --exclude='*' $ANGLE_FOLDER/include/ $GLESV2_HEADERS_DIR
cp $ANGLE_FOLDER/include/angle_gl.h $GLESV2_HEADERS_DIR

for RELATIVE_PATH in `find $GLESV2_HEADERS_DIR -type f -name "*.h" | sed "s|^${GLESV2_HEADERS_DIR}/||"`; do
    FILE_NAME=`basename $RELATIVE_PATH`

    TO_REPLACE="<$RELATIVE_PATH>"
    NEW_STRING="<libGLESv2/$RELATIVE_PATH>"

    sed -ie "s#${TO_REPLACE}#${NEW_STRING}#g" `find $GLESV2_HEADERS_DIR -name "*.h"`

    TO_REPLACE="\"$RELATIVE_PATH\""
    NEW_STRING="<libGLESv2/$RELATIVE_PATH>"

    sed -ie "s#${TO_REPLACE}#${NEW_STRING}#g" `find $GLESV2_HEADERS_DIR -name "*.h"`

    TO_REPLACE="\"$FILE_NAME\""
    NEW_STRING="<libGLESv2/$RELATIVE_PATH>"

    sed -ie "s#${TO_REPLACE}#${NEW_STRING}#g" `find $GLESV2_HEADERS_DIR -name "*.h"`
done

rm -rf $GLESV2_HEADERS_DIR/**/*.he
