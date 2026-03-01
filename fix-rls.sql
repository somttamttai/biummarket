-- ============================================================
-- products 테이블 RLS 정책 수정
-- Supabase Dashboard > SQL Editor에서 실행하세요.
-- ============================================================

-- anon(비로그인) 사용자도 상품을 INSERT할 수 있도록 허용
-- (앱의 자동 샘플 삽입 기능 + 판매자 상품 등록을 위해 필요)

-- 기존 INSERT 정책이 있으면 삭제 후 재생성
DROP POLICY IF EXISTS "Allow anon insert" ON products;
DROP POLICY IF EXISTS "anon_insert" ON products;

-- SELECT: 모든 사용자 허용
DROP POLICY IF EXISTS "Allow public read" ON products;
CREATE POLICY "Allow public read"
  ON products FOR SELECT
  TO anon, authenticated
  USING (true);

-- INSERT: anon 및 인증 사용자 모두 허용
CREATE POLICY "Allow anon insert"
  ON products FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- UPDATE: 인증 사용자만 허용
DROP POLICY IF EXISTS "Allow authenticated update" ON products;
CREATE POLICY "Allow authenticated update"
  ON products FOR UPDATE
  TO authenticated
  USING (true);

-- DELETE: 인증 사용자 + anon 허용 (현재 anon DELETE는 이미 동작 중)
DROP POLICY IF EXISTS "Allow anon delete" ON products;
CREATE POLICY "Allow anon delete"
  ON products FOR DELETE
  TO anon, authenticated
  USING (true);

-- 현재 정책 확인
SELECT policyname, cmd, roles
FROM pg_policies
WHERE tablename = 'products';
