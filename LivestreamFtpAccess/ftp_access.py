#!/usr/bin/python3

import ftplib
import io

VIDEO_ID_FILENAME = 'videoId.txt'


def upload_ftp_livestream_data(
        ftp_host: str,
        ftp_user: str,
        ftp_password: str,
        video_id: str,
        use_tls: bool = True,
        ) -> bool:
    '''Uploads given livestream data via FTP'''

    ftp_class = ftplib.FTP_TLS if use_tls else ftplib.FTP

    with ftp_class(ftp_host) as ftp:
        try:
            ftp.login(ftp_user, ftp_password)
            
            if use_tls:
                ftp.prot_p()  # Set communication to be secured via TLS

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


if __name__ == '__main__':
    from dotenv import dotenv_values

    env_values = dotenv_values()
    ftp_host = env_values.get('FTP_HOST', 'test_host')
    ftp_user = env_values.get('FTP_USER', 'test_user')
    ftp_password = env_values.get('FTP_PASSWORD', 'test_password')
    video_id = 'xyzID'

    upload_ftp_livestream_data(ftp_host, ftp_user, ftp_password, video_id)
