import { useEffect, useRef, useState } from 'react';
import { Animated, GestureResponderEvent, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { colors, fonts, USE_NATIVE_DRIVER } from '../theme';
import { parseContent, type FlatPage } from '../types';
import InteractiveElementCard from './InteractiveElementCard';

interface SparkleSpec {
  id: number;
  x: number;
  y: number;
}

/** 탭한 자리에서 피어났다 사라지는 반짝임 */
function Sparkle({ x, y, onDone }: { x: number; y: number; onDone: () => void }) {
  const progress = useRef(new Animated.Value(0)).current;
  const onDoneRef = useRef(onDone);
  onDoneRef.current = onDone;

  useEffect(() => {
    Animated.timing(progress, { toValue: 1, duration: 700, useNativeDriver: USE_NATIVE_DRIVER }).start(
      ({ finished }) => {
        if (finished) onDoneRef.current();
      }
    );
  }, [progress]);

  const scale = progress.interpolate({ inputRange: [0, 0.3, 1], outputRange: [0.3, 1.3, 1] });
  const translateY = progress.interpolate({ inputRange: [0, 1], outputRange: [0, -26] });
  const opacity = progress.interpolate({ inputRange: [0, 0.2, 1], outputRange: [0, 1, 0] });

  return (
    <Animated.Text
      pointerEvents="none"
      style={[styles.sparkle, { left: x - 10, top: y - 10, opacity, transform: [{ scale }, { translateY }] }]}
    >
      ✦
    </Animated.Text>
  );
}

export default function BookPageView({ page, width }: { page: FlatPage; width: number }) {
  const [sparkles, setSparkles] = useState<SparkleSpec[]>([]);
  const nextId = useRef(0);

  const addSparkle = (event: GestureResponderEvent) => {
    const { locationX, locationY } = event.nativeEvent;
    const id = nextId.current++;
    setSparkles((prev) => [...prev, { id, x: locationX, y: locationY }]);
  };

  const removeSparkle = (id: number) => {
    setSparkles((prev) => prev.filter((s) => s.id !== id));
  };

  const blocks = parseContent(page.content);

  return (
    <ScrollView style={{ width }} contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
      <Pressable onPress={addSparkle}>
        {blocks.map((block, index) => {
          if (block.type === 'h1') {
            return (
              <View key={index}>
                <Text style={styles.ornament}>❖</Text>
                <Text style={styles.h1}>{block.text}</Text>
              </View>
            );
          }
          if (block.type === 'h3') {
            return (
              <Text key={index} style={styles.h3}>
                {block.text}
              </Text>
            );
          }
          if (block.type === 'quote') {
            return (
              <View key={index} style={styles.quoteWrap}>
                <Text style={styles.quote}>{block.text}</Text>
              </View>
            );
          }
          return (
            <Text key={index} style={styles.p}>
              {block.text}
            </Text>
          );
        })}

        {page.interactiveElements.map((element) => (
          <InteractiveElementCard key={element.id} element={element} />
        ))}

        {sparkles.map((s) => (
          <Sparkle key={s.id} x={s.x} y={s.y} onDone={() => removeSparkle(s.id)} />
        ))}
      </Pressable>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  content: {
    paddingHorizontal: 28,
    paddingTop: 28,
    paddingBottom: 72,
  },
  ornament: {
    fontFamily: fonts.serif,
    fontSize: 14,
    color: colors.inkSoft,
    textAlign: 'center',
    marginBottom: 14,
  },
  h1: {
    fontFamily: fonts.serifXBold,
    fontSize: 22,
    lineHeight: 34,
    color: colors.ink,
    textAlign: 'center',
    marginBottom: 26,
  },
  h3: {
    fontFamily: fonts.serifBold,
    fontSize: 17,
    lineHeight: 28,
    color: colors.accent,
    marginTop: 22,
    marginBottom: 10,
  },
  p: {
    fontFamily: fonts.serif,
    fontSize: 15.5,
    lineHeight: 29,
    color: colors.ink,
    marginBottom: 16,
  },
  quoteWrap: {
    borderLeftWidth: 2,
    borderLeftColor: colors.noteBorder,
    paddingLeft: 16,
    marginVertical: 6,
    marginBottom: 18,
  },
  quote: {
    fontFamily: fonts.serifBold,
    fontSize: 15.5,
    lineHeight: 28,
    color: colors.inkSoft,
  },
  sparkle: {
    position: 'absolute',
    fontSize: 20,
    color: colors.accent,
  },
});
