export interface InteractiveElement {
  id: string;
  type: string; // 'note' | 'link'
  label: string;
  actionUrl?: string;
}

export interface BookPage {
  id: string;
  pageNumber: number;
  imageUrl?: string;
  content: string;
  interactiveElements: InteractiveElement[];
}

export interface Chapter {
  id: string;
  title: string;
  pages: BookPage[];
}

export interface Book {
  id: string;
  title: string;
  description: string;
  author: string;
  totalPages: number;
  chapters: Chapter[];
}

/** 리더에서 쓰는 평탄화된 페이지: 소속 챕터 정보를 함께 갖는다 */
export interface FlatPage extends BookPage {
  chapterTitle: string;
  chapterIndex: number;
}

export function flattenPages(book: Book): FlatPage[] {
  return book.chapters.flatMap((chapter, chapterIndex) =>
    chapter.pages.map((page) => ({
      ...page,
      chapterTitle: chapter.title,
      chapterIndex,
    }))
  );
}

export type ContentBlock =
  | { type: 'h1'; text: string }
  | { type: 'h3'; text: string }
  | { type: 'quote'; text: string }
  | { type: 'p'; text: string };

/** book_data.json의 마크다운 본문(#, ###, 따옴표 인용, 문단)을 블록으로 파싱 */
export function parseContent(content: string): ContentBlock[] {
  return content
    .split('\n')
    .map((line) => line.trim())
    .filter((line) => line.length > 0)
    .map((line) => {
      if (line.startsWith('# ')) return { type: 'h1' as const, text: line.slice(2) };
      if (line.startsWith('### ')) return { type: 'h3' as const, text: line.slice(4) };
      if (line.startsWith('"') || line.startsWith('“')) return { type: 'quote' as const, text: line };
      return { type: 'p' as const, text: line };
    });
}
