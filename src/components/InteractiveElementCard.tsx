import { useEffect, useRef, useState } from 'react';
import { Animated, Linking, Pressable, StyleSheet, Text, View } from 'react-native';
import { colors, fonts, USE_NATIVE_DRIVER } from '../theme';
import type { InteractiveElement } from '../types';

/** 펼쳐질 때 부드럽게 나타나는 본문 */
function FadeInText({ children, style }: { children: string; style: object }) {
  const opacity = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(opacity, { toValue: 1, duration: 350, useNativeDriver: USE_NATIVE_DRIVER }).start();
  }, [opacity]);

  return <Animated.Text style={[style, { opacity }]}>{children}</Animated.Text>;
}

export default function InteractiveElementCard({ element }: { element: InteractiveElement }) {
  const [expanded, setExpanded] = useState(false);

  if (element.type === 'link') {
    return (
      <Pressable
        style={({ pressed }) => [styles.card, styles.linkCard, pressed && styles.pressed]}
        onPress={() => {
          if (element.actionUrl) Linking.openURL(element.actionUrl);
        }}
      >
        <Text style={styles.linkHeader}>🔗 함께 보기</Text>
        <Text style={styles.linkLabel}>
          {element.label} <Text style={styles.linkArrow}>↗</Text>
        </Text>
      </Pressable>
    );
  }

  return (
    <Pressable
      style={({ pressed }) => [styles.card, styles.noteCard, pressed && styles.pressed]}
      onPress={() => setExpanded((v) => !v)}
    >
      <View style={styles.noteHeaderRow}>
        <Text style={styles.noteHeader}>🖋 저자의 노트</Text>
        <Text style={styles.noteToggle}>{expanded ? '접기 ▲' : '펼치기 ▼'}</Text>
      </View>
      {expanded && <FadeInText style={styles.noteBody}>{element.label}</FadeInText>}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: 14,
    borderWidth: 1,
    paddingVertical: 14,
    paddingHorizontal: 16,
    marginTop: 14,
  },
  pressed: {
    opacity: 0.85,
  },
  noteCard: {
    backgroundColor: colors.noteBg,
    borderColor: colors.noteBorder,
  },
  noteHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  noteHeader: {
    fontFamily: fonts.serifBold,
    fontSize: 14,
    color: colors.noteText,
  },
  noteToggle: {
    fontFamily: fonts.serif,
    fontSize: 12,
    color: colors.noteText,
    opacity: 0.7,
  },
  noteBody: {
    fontFamily: fonts.serif,
    fontSize: 14,
    lineHeight: 25,
    color: colors.noteText,
    marginTop: 12,
  },
  linkCard: {
    backgroundColor: colors.linkBg,
    borderColor: colors.linkBorder,
  },
  linkHeader: {
    fontFamily: fonts.serifBold,
    fontSize: 14,
    color: colors.linkText,
  },
  linkLabel: {
    fontFamily: fonts.serif,
    fontSize: 14,
    lineHeight: 25,
    color: colors.linkText,
    marginTop: 8,
  },
  linkArrow: {
    fontFamily: fonts.serifBold,
    fontSize: 14,
  },
});
