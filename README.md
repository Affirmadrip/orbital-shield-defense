**เกม Astral Impact - Coding แต่ละส่วน**

**1. Stage (ตะวัน, บูม)**
- ทำการ Spawn ของ Alien (Alien เกิดขอบจอ มุ่งเข้าหาดาวเคราะห์ ไม่ได้มุ่งเข้าหาตำแหน่ง Player)
- ทำ Stats ของ Alien - ความเร็ว, HP ของ Alien, สี Alien, Damage (ทำ Damage กับ Barrier และทำลายตัวเอง)
- ทำพื้นหลัง, ดาวเคราะห์, Barrier และ HP ของ Barrier
- ทำระบบของ Stage - อัตราการ Spawn ของ Alien, เวลาที่กำหนดใน Stage, คะแนนเป้าหมาย
- ทำเงื่อนไขการจบเกม (ทั้งเงื่อนไขการชนะและเงื่อนไขการแพ้)

**2. Player character (โอมาร์)**
- ทำระบบวงโคจรที่ผู้เล่นสามารถหมุนได้รอบดาวเคราะห์
- ทำปุ่ม Control ควบคุมการเคลื่อนที่ (ปุ่ม A, D)
- ทำระบบการยิง - กระสุนธรรมดา คลิกซ้าย กระสุนลูกใหญ่ คลิกซ้ายค้าง (ชาร์จกระสุน) 
- ทำ Stats ของกระสุน - Damage กระสุน, ระยะกระสุน

**3. Main Menu (กิม)**
- Start Game (เริ่มที่ Stage 1)
- Tutorial
    - อธิบายปุ่ม
    - อธิบายเงื่อนไขการชนะ เงื่อนไขการแพ้
    - Back
- Settings
    - SFX Volume
    - Music Volume
    - Back
- Credits
    - งานภาพ (Visual)
    - เสียง (Audio)
    - Code
    - Tools
- Quit

**4. UI ในเกม (กิม, มาร์ค)**
- เมนู Pause (กดปุ่ม ESC)
    - Resume
    - Restart
    - Main Menu
- เมื่อ Clear ด่านที่ 1 สำเร็จ
    - แสดงคะแนนที่ทำได้
    - Next Stage
    - Main Menu
- เมื่อ Clear ด่านที่ 2 สำเร็จ
    - แสดงคะแนนที่ทำได้
    - Play Again
    - Main Menu
- Game Over (แพ้)
    - ถ้าแพ้เพราะ HP ของ Barrier เหลือ 0 = Barrier Destroyed หรือถ้าแพ้เพราะเวลาหมดแล้วคะแนนไม่ถึง = Time Up 
    - Retry
    - Main Menu
