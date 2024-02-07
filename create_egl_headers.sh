#!/bin/zsh

ANGLE_FOLDER=$1
EGL_HEADERS_DIR=$2

rsync -av --prune-empty-dirs --include='*/' --include='EGL/*.h' --exclude='*' $ANGLE_FOLDER/include/ $EGL_HEADERS_DIR
rsync -av --prune-empty-dirs --include='*/' --include='KHR/*.h' --exclude='*' $ANGLE_FOLDER/include/ $EGL_HEADERS_DIR

for RELATIVE_PATH in `find $EGL_HEADERS_DIR -type f -name "*.h" | sed "s|^${EGL_HEADERS_DIR}/||"`; do
    FILE_NAME=`basename $RELATIVE_PATH`

    TO_REPLACE="<$RELATIVE_PATH>"
    NEW_STRING="<libEGL/$RELATIVE_PATH>"

    sed -ie "s#${TO_REPLACE}#${NEW_STRING}#g" `find $EGL_HEADERS_DIR -name "*.h"`

    TO_REPLACE="\"$RELATIVE_PATH\""
    NEW_STRING="<libEGL/$RELATIVE_PATH>"

    sed -ie "s#${TO_REPLACE}#${NEW_STRING}#g" `find $EGL_HEADERS_DIR -name "*.h"`

    TO_REPLACE="\"$FILE_NAME\""
    NEW_STRING="<libEGL/$RELATIVE_PATH>"

    sed -ie "s#${TO_REPLACE}#${NEW_STRING}#g" `find $EGL_HEADERS_DIR -name "*.h"`
done

rm -rf $EGL_HEADERS_DIR/**/*.he
