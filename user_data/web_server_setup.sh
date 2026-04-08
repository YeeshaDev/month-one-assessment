#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# page showing the instance ID and availability zone
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat <<EOF > /var/www/html/index.html
<html>
<head>
  <title>TechCorp Web Server</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #0f172a, #1e293b);
      color: #e2e8f0;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .card {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 16px;
      padding: 48px;
      max-width: 500px;
      width: 90%;
      text-align: center;
      backdrop-filter: blur(10px);
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    }
    .logo {
      font-size: 48px;
      margin-bottom: 16px;
    }
    h1 {
      font-size: 28px;
      font-weight: 700;
      margin-bottom: 8px;
      color: #38bdf8;
    }
    .subtitle {
      color: #94a3b8;
      font-size: 14px;
      margin-bottom: 32px;
    }
    .info {
      background: rgba(56, 189, 248, 0.08);
      border: 1px solid rgba(56, 189, 248, 0.2);
      border-radius: 10px;
      padding: 20px;
      text-align: left;
    }
    .info-row {
      display: flex;
      justify-content: space-between;
      padding: 10px 0;
      border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }
    .info-row:last-child { border-bottom: none; }
    .label {
      color: #94a3b8;
      font-size: 13px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .value {
      color: #f1f5f9;
      font-size: 14px;
      font-family: 'Courier New', monospace;
    }
    .status {
      display: inline-block;
      margin-top: 24px;
      padding: 6px 16px;
      background: rgba(34, 197, 94, 0.15);
      border: 1px solid rgba(34, 197, 94, 0.3);
      border-radius: 20px;
      color: #4ade80;
      font-size: 13px;
      font-weight: 600;
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="logo">&#9729;</div>
    <h1>TechCorp</h1>
    <p class="subtitle">Cloud Infrastructure Assessment</p>
    <p style="margin-top: 12px; color: #38bdf8; font-size: 16px; font-weight: 600;">Agunbiade Aishat Olabisi</p>
    <div class="info">
      <div class="info-row">
        <span class="label">Instance ID</span>
        <span class="value">${INSTANCE_ID}</span>
      </div>
      <div class="info-row">
        <span class="label">Availability Zone</span>
        <span class="value">${AZ}</span>
      </div>
    </div>
    <span class="status">&#9679; Running</span>
  </div>
</body>
</html>
EOF

# Enable password authentication for SSH
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "webadmin:${web_password}" | chpasswd
systemctl restart sshd
