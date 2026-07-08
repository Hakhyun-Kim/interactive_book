import { useEffect, useRef } from 'react';
import { Animated, Pressable, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors, fonts, USE_NATIVE_DRIVER } from '../theme';
import type { Book } from '../types';

interface Props {
  book: Book;
  onStart: () => void;
}

/** 좌우로 천천히 떠다니는 구름 한 점 */
function DriftingCloud({ top, size, duration, delay }: { top: number; size: number; duration: number; delay: number }) {
  const drift = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    const loop = Animated.loop(
      Animated.sequence([
        Animated.timing(drift, { toValue: 1, duration, delay, useNativeDriver: USE_NATIVE_DRIVER }),
        Animated.timing(drift, { toValue: 0, duration, useNativeDriver: USE_NATIVE_DRIVER }),
      ])
    );
    loop.start();
    return () => loop.stop();
  }, [drift, duration, delay]);

  const translateX = drift.interpolate({ inputRange: [0, 1], outputRange: [-30, 30] });
  const opacity = drift.interpolate({ inputRange: [0, 0.5, 1], outputRange: [0.35, 0.6, 0.35] });

  return (
    <Animated.Text style={[styles.cloud, { top, fontSize: size, opacity, transform: [{ translateX }] }]}>
      ☁️
    </Animated.Text>
  );
}

export default function CoverScreen({ book, onStart }: Props) {
  const insets = useSafeAreaInsets();
  const fadeIn = useRef(new Animated.Value(0)).current;
  const buttonScale = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    Animated.timing(fadeIn, { toValue: 1, duration: 900, useNativeDriver: USE_NATIVE_DRIVER }).start();
  }, [fadeIn]);

  return (
    <View style={[styles.container, { paddingTop: insets.top + 24, paddingBottom: insets.bottom + 32 }]}>
      <DriftingCloud top={90} size={44} duration={9000} delay={0} />
      <DriftingCloud top={170} size={30} duration={7000} delay={1500} />

      <Animated.View style={[styles.body, { opacity: fadeIn }]}>
        <Text style={styles.kicker}>인터랙티브 에세이</Text>
        <Text style={styles.title}>{book.title}</Text>
        <View style={styles.divider} />
        <Text style={styles.description}>{book.description}</Text>
        <Text style={styles.author}>{book.author}</Text>
      </Animated.View>

      <Animated.View style={{ transform: [{ scale: buttonScale }] }}>
        <Pressable
          style={styles.startButton}
          onPress={onStart}
          onPressIn={() =>
            Animated.spring(buttonScale, { toValue: 0.95, useNativeDriver: USE_NATIVE_DRIVER }).start()
          }
          onPressOut={() =>
            Animated.spring(buttonScale, { toValue: 1, useNativeDriver: USE_NATIVE_DRIVER }).start()
          }
        >
          <Text style={styles.startButtonText}>읽기 시작하기</Text>
        </Pressable>
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.cover,
    paddingHorizontal: 32,
    justifyContent: 'flex-end',
  },
  cloud: {
    position: 'absolute',
    left: '55%',
  },
  body: {
    flex: 1,
    justifyContent: 'center',
  },
  kicker: {
    fontFamily: fonts.serif,
    fontSize: 14,
    letterSpacing: 4,
    color: colors.coverSoft,
    marginBottom: 18,
  },
  title: {
    fontFamily: fonts.serifXBold,
    fontSize: 34,
    lineHeight: 50,
    color: colors.coverText,
  },
  divider: {
    width: 48,
    height: 2,
    backgroundColor: colors.coverSoft,
    marginVertical: 24,
  },
  description: {
    fontFamily: fonts.serif,
    fontSize: 15,
    lineHeight: 27,
    color: colors.coverSoft,
  },
  author: {
    fontFamily: fonts.serifBold,
    fontSize: 14,
    color: colors.coverText,
    marginTop: 20,
  },
  startButton: {
    backgroundColor: colors.coverText,
    borderRadius: 999,
    paddingVertical: 16,
    alignItems: 'center',
  },
  startButtonText: {
    fontFamily: fonts.serifBold,
    fontSize: 16,
    color: colors.cover,
  },
});
