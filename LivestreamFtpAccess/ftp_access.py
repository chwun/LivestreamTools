#!/usr/bin/python3

import ftplib
import io
import os
from dotenv import load_dotenv

load_dotenv()

VIDEO_ID_FILENAME = 'videoId.txt'


def upload_ftp_livestream_data(video_id: str) -> bool:
    '''Uploads given livestream data via FTP'''

    ftp_host = os.getenv('FTP_HOST')

    with ftplib.FTP(ftp_host) as ftp:
        try:
            ftp_user = os.getenv('FTP_USER')
            ftp_password = os.getenv('FTP_PASSWORD')

            ftp.login(ftp_user, ftp_password)

            bio = io.BytesIO()
            bio.write(video_id.encode())
            bio.seek(0)

            result = ftp.storlines('STOR ' + VIDEO_ID_FILENAME, bio)
            print(result)

            if not result.startswith('226'):
                return False

            return True

        except ftplib.all_errors as ftp_error:
            print('FTP error:', ftp_error)
            return False


upload_ftp_livestream_data('xyz')
