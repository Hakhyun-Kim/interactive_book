import { useEffect, useMemo, useRef, useState } from 'react';
import {
  Animated,
  FlatList,
  NativeScrollEvent,
  NativeSyntheticEvent,
  Pressable,
  StyleSheet,
  Text,
  useWindowDimensions,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors, fonts, USE_NATIVE_DRIVER } from '../theme';
import { flattenPages, type Book, type FlatPage } from '../types';
import BookPageView from './BookPageView';

interface Props {
  book: Book;
  onClose: () => void;
}

export default function ReaderScreen({ book, onClose }: Props) {
  const { width, height: windowHeight } = useWindowDimensions();
  const insets = useSafeAreaInsets();
  const pages = useMemo(() => flattenPages(book), [book]);
  const [pageIndex, setPageIndex] = useState(0);
  const [measuredHeight, setMeasuredHeight] = useState(0);
  // onLayout 측정 전에도 렌더링되도록 윈도 높이를 폴백으로 사용
  const pageHeight = measuredHeight > 0 ? measuredHeight : windowHeight;
  const progress = useRef(new Animated.Value(1 / pages.length)).current;

  useEffect(() => {
    Animated.timing(progress, {
      toValue: (pageIndex + 1) / pages.length,
      duration: 300,
      useNativeDriver: USE_NATIVE_DRIVER,
    }).start();
  }, [progress, pageIndex, pages.length]);

  const handleScroll = (event: NativeSyntheticEvent<NativeScrollEvent>) => {
    const index = Math.round(event.nativeEvent.contentOffset.x / width);
    if (index !== pageIndex && index >= 0 && index < pages.length) {
      setPageIndex(index);
    }
  };

  const currentPage = pages[pageIndex];

  return (
    <View style={[styles.container, { paddingTop: insets.top }]}>
      <View style={styles.header}>
        <Pressable onPress={onClose} hitSlop={12} style={styles.backButton}>
          <Text style={styles.backButtonText}>‹</Text>
        </Pressable>
        <Text style={styles.chapterTitle} numberOfLines={1}>
          {currentPage.chapterTitle}
        </Text>
        <Text style={styles.pageCount}>
          {pageIndex + 1} / {pages.length}
        </Text>
      </View>

      <View style={styles.progressTrack}>
        <Animated.View style={[styles.progressFill, { transform: [{ scaleX: progress }] }]} />
      </View>

      <View
        style={styles.listArea}
        onLayout={(event) => setMeasuredHeight(Math.round(event.nativeEvent.layout.height))}
      >
        <FlatList<FlatPage>
          data={pages}
          horizontal
          pagingEnabled
          showsHorizontalScrollIndicator={false}
          keyExtractor={(page) => page.id}
          renderItem={({ item }) => <BookPageView page={item} width={width} height={pageHeight} />}
          onScroll={handleScroll}
          scrollEventThrottle={32}
          getItemLayout={(_, index) => ({ length: width, offset: width * index, index })}
        />
      </View>

      <Text style={[styles.hint, { paddingBottom: insets.bottom + 10 }]}>옆으로 밀어 페이지를 넘기세요</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.paper,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 10,
    gap: 12,
  },
  backButton: {
    width: 32,
    alignItems: 'center',
  },
  backButtonText: {
    fontFamily: fonts.serifBold,
    fontSize: 28,
    lineHeight: 32,
    color: colors.ink,
  },
  chapterTitle: {
    flex: 1,
    fontFamily: fonts.serifBold,
    fontSize: 14,
    color: colors.ink,
    textAlign: 'center',
  },
  pageCount: {
    fontFamily: fonts.serif,
    fontSize: 12,
    color: colors.inkSoft,
    width: 40,
    textAlign: 'right',
  },
  listArea: {
    flex: 1,
  },
  progressTrack: {
    height: 3,
    backgroundColor: colors.paperDeep,
    marginHorizontal: 16,
    borderRadius: 999,
    overflow: 'hidden',
  },
  progressFill: {
    width: '100%',
    height: '100%',
    backgroundColor: colors.accent,
    borderRadius: 999,
    transformOrigin: 'left',
  },
  hint: {
    fontFamily: fonts.serif,
    fontSize: 11,
    color: colors.inkSoft,
    textAlign: 'center',
    paddingTop: 8,
  },
});
