import { Platform } from 'react-native';

export const colors = {
  paper: '#F7F2E9',
  paperDeep: '#EFE7D8',
  ink: '#2E2A24',
  inkSoft: '#6F675B',
  hairline: '#DDD3C2',

  cover: '#22334A',
  coverSoft: '#8FA3BC',
  coverText: '#F3EDE1',
  accent: '#3E5C76',

  noteBg: '#F1E7CF',
  noteBorder: '#DCC898',
  noteText: '#5C4A21',

  linkBg: '#E4EAF0',
  linkBorder: '#C3D0DC',
  linkText: '#2F4A63',
};

export const fonts = {
  serif: 'NanumMyeongjo_400Regular',
  serifBold: 'NanumMyeongjo_700Bold',
  serifXBold: 'NanumMyeongjo_800ExtraBold',
};

/** RNW는 네이티브 드라이버를 지원하지 않으므로 웹에서는 JS 드라이버로 폴백 */
export const USE_NATIVE_DRIVER = Platform.OS !== 'web';
