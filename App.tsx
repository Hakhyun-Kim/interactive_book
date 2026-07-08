import {
  NanumMyeongjo_400Regular,
  NanumMyeongjo_700Bold,
  NanumMyeongjo_800ExtraBold,
  useFonts,
} from '@expo-google-fonts/nanum-myeongjo';
import { StatusBar } from 'expo-status-bar';
import { useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import bookData from './data/book_data.json';
import CoverScreen from './src/components/CoverScreen';
import ReaderScreen from './src/components/ReaderScreen';
import { colors } from './src/theme';
import type { Book } from './src/types';

const book: Book = bookData.books[0];

export default function App() {
  const [reading, setReading] = useState(false);
  const [fontsLoaded] = useFonts({
    NanumMyeongjo_400Regular,
    NanumMyeongjo_700Bold,
    NanumMyeongjo_800ExtraBold,
  });

  if (!fontsLoaded) {
    return <View style={styles.loading} />;
  }

  return (
    <SafeAreaProvider>
      <StatusBar style={reading ? 'dark' : 'light'} />
      {reading ? (
        <ReaderScreen book={book} onClose={() => setReading(false)} />
      ) : (
        <CoverScreen book={book} onStart={() => setReading(true)} />
      )}
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  loading: {
    flex: 1,
    backgroundColor: colors.cover,
  },
});
