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

# --- หมวดหมู่ใหม่: VPN & Remote Access ---
with st.expander("🔐 VPN & Remote Access (คลิกเพื่อดูช่องทางเชื่อมต่อ)", expanded=True):
    col_vpn1, col_vpn2 = st.columns(2)
    with col_vpn1:
        # ใส่ URL สำหรับหน้า Web VPN หรือหน้าดาวน์โหลดของบริษัทคุณ
        st.link_button("🌐 Connect Web VPN", "https://your-vpn-link.com", use_container_width=True)
    with col_vpn2:
        # ใส่ลิงก์คู่มือการต่อ VPN
        st.link_button("📖 คู่มือการติดตั้ง VPN", "https://your-manual-link.com", use_container_width=True)
    st.caption("⚠️ โปรดเชื่อมต่อ VPN ก่อนเข้าใช้งานระบบ Internal Server")

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
