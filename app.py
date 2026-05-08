import streamlit as st

# 1. การตั้งค่าหน้าเว็บ
st.set_page_config(
    page_title="JVFS Work Portal", 
    page_icon="📂", 
    layout="centered"
)

# 2. ปรับแต่งสไตล์ด้วย CSS
st.markdown("""
<style>
    .stButton>button {
        border-radius: 10px;
        height: 3em;
        transition: all 0.3s;
    }
    .stButton>button:hover {
        border-color: #007bff;
        color: #007bff;
        transform: scale(1.02);
    }
    .vpn-section {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 10px;
        border-left: 5px solid #ff4b4b;
    }
</style>
""", unsafe_allow_html=True)

# 3. ส่วนเนื้อหา
st.title("📂 JVFS Work Portal")
st.write("ศูนย์รวมลิงก์ระบบงานและเอกสารสำคัญ")

import streamlit as st

    # เพิ่มปุ่ม One-Click ใน app.py
st.subheader("⚡ JVFS VPN Quick Connect")

st.markdown("""
<style>
    /* ปรับปุ่มทั่วไป */
    .stButton>button {
        border-radius: 10px;
        height: 3em;
        transition: all 0.3s;
    }
    
    /* แก้ไขสีตัวอักษรใน Warning/Info Box ให้เป็นสีดำเพื่อให้มองเห็นชัดบนพื้นหลังเหลือง */
    .stAlert p {
        color: #111111 !important;
        font-weight: 500;
    }

    /* ตกแต่งส่วน Quick Connect ให้เด่น */
    .quick-connect-box {
        background-color: #262730;
        padding: 20px;
        border-radius: 15px;
        border: 1px solid #464b5d;
        margin-bottom: 20px;
    }
</style>
""", unsafe_allow_html=True)
st.warning("⚠️ ขั้นตอนแรก: ดาวน์โหลดและรันไฟล์ด้านล่างนี้เพียงครั้งเดียว")

# ใส่ลิงก์ Raw จาก GitHub ของคุณที่นี่
github_raw_url = "https://raw.githubusercontent.com/USER_NAME/REPO_NAME/main/setup_vpn.bat"

# ปุ่มดาวน์โหลดไฟล์
st.link_button("📥ดาวน์โหลดไฟล์ Setup (คลิกขวา Save As)", github_raw_url, use_container_width=True)

st.markdown("""
<div style="font-size: 0.85rem; color: #888; margin-bottom: 15px;">
    <i>*หลังจากโหลดแล้ว ให้คลิกขวาที่ไฟล์เลือก <b>'Run as Administrator'</b></i>
</div>
""", unsafe_allow_html=True)

# ปุ่ม One-Click Connect
st.link_button("🚀 ONE-CLICK CONNECT", "jvfs-connect://", type="primary", use_container_width=True)

st.caption("เมื่อกดแล้ว โปรแกรม FortiClient จะเด้งขึ้นมาให้ใส่ Password และต่อให้ทันที")
    
st.divider()

# --- กลุ่มที่ 1: ระบบงานหลัก ---
st.subheader("🛠️ Core Systems")
col1, col2 = st.columns(2)

with col1:
    st.link_button("🌐 e-Workpermit OS (Main)", "https://eworkpermitos.doe.go.th/Main", use_container_width=True)
    st.link_button("📄 e-Workpermit System", "https://eworkpermit.doe.go.th/", use_container_width=True)
    st.link_button("💬 LINE Official Account", "https://account.line.biz/login?redirectUri=https%3A%2F%2Fmanager.line.biz%2F", use_container_width=True)

with col2:
    st.link_button("☁️ Wesgan Asset Setting", "https://cloud.wesgan.com/fts/Asset/Setting", use_container_width=True)
    st.link_button("✨ Google Gemini (AI)", "https://gemini.google.com/app", type="primary", use_container_width=True)
    st.link_button("🖥️ ระบบบันทึก Log การแก้ไขข้อมูลบัตร", "http://jvfs-srv:8501/", use_container_width=True)
st.divider()

# --- กลุ่มที่ 2: เอกสาร SharePoint ---
st.subheader("📁 IT Resources & SharePoint")

st.link_button("📊 JVFS-Branch InfoList (Excel)", "https://jvfuturesky.sharepoint.com/:x:/r/sites/jvfs-it/_layouts/15/doc2.aspx?sourcedoc={7D495EC0-5278-476D-A12F-17B1ACB60652}&file=JVFS-Branch-InfoList.xlsx&action=default&mobileredirect=true", use_container_width=True)

st.link_button("🖨️ JVFS-Printer Usercode List", "https://jvfuturesky.sharepoint.com/:x:/r/sites/jvfs-it/_layouts/15/doc2.aspx?sourcedoc={4F7823C2-C78E-4C90-81C5-E1C648914A9A}&file=JVFS-PrinterUsercode-List.xlsx&action=default&mobileredirect=true", use_container_width=True)

col3, col4 = st.columns(2)
with col3:
    st.link_button("📝JVFS-Employee-Status", "https://jvfuturesky.sharepoint.com/:x:/r/sites/jvfs-it/_layouts/15/doc2.aspx?sourcedoc={a0d07f9a-f12b-4376-9f8e-c4bf13615cd3}&action=edit", use_container_width=True)
with col4:
    st.link_button("🔗JVFS-ITSupport-Credential", "https://jvfuturesky.sharepoint.com/:x:/s/jvfs-it/EZGs2aN4k3tEvr46UpUTZkIBfePqsghEiqB7MueqcSXeWA?e=H3VEsB", use_container_width=True)

st.divider()
