import streamlit as st

# ตั้งค่าหน้าเว็บ
st.set_page_config(page_title="My Work Portal", page_icon="🌐", layout="centered")

# ส่วนหัวของหน้าเว็บ
st.title("🚀 Work Portal Dashboard")
st.write("รวมลิงก์สำคัญสำหรับการทำงานไว้ในที่เดียว")

st.divider()

# สร้างปุ่มสำหรับลิงก์ต่างๆ
# ใช้คอลัมน์เพื่อให้ UI ดูสมดุล
col1, col2 = st.columns(2)

with col1:
    st.subheader("Department of Employment")
    st.link_button("🌐 e-Workpermit OS (Main)", "https://eworkpermitos.doe.go.th/Main", use_container_width=True)
    st.link_button("📄 e-Workpermit System", "https://eworkpermit.doe.go.th/", use_container_width=True)

with col2:
    st.subheader("AI Tools")
    st.link_button("✨ Google Gemini", "https://gemini.google.com/app", type="primary", use_container_width=True)

st.divider()
st.caption("พัฒนาด้วย Streamlit | เข้าใช้งานได้ทุกที่ทุกเวลา")
