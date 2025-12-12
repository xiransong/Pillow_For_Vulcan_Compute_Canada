# 🧵 Step-by-Step: Build Pillow 11.3.0 manylinux2014 Wheel

This repository provides a **reproducible, step-by-step workflow** to build a **manylinux2014-compatible wheel** for **Pillow 11.3.0 (Python 3.11)** using **GitHub Codespaces** and **Docker**.

This is particularly useful for **HPC environments** (e.g., Compute Canada) where:

* building Pillow from source fails due to system headers,
* pip attempts to compile C extensions,
* or prebuilt wheels are unavailable / incompatible.

---

## ✅ What This Produces

After following this guide, you will obtain a wheel like:

```
pillow-11.3.0-cp311-cp311-manylinux2014_x86_64.whl
```

This wheel:

* is **auditwheel-repaired**
* embeds required shared libraries
* can be transferred and installed via `pip install <wheel>.whl`
* avoids *any* source compilation on the target machine

---

## 📁 Repository Structure

```
.
├── .devcontainer/
│   └── devcontainer.json
├── Dockerfile
├── build_pillow.sh
└── README.md
```

---

## 🧰 Prerequisites

* A GitHub account
* GitHub Codespaces enabled
* No local Docker installation required

---

## 🚀 Step 1 — Open the Repository in GitHub Codespaces

1. Push this repository to GitHub.
2. Click **Code → Codespaces → Create codespace**.
3. Wait until the devcontainer finishes building.
4. You should see:

   ```
   Codespace ready!
   ```

This environment already includes:

* Docker (inside Codespaces)
* Python tooling
* Everything needed to run manylinux containers

---

## 🐳 Step 2 — Verify Docker Works

Inside the Codespaces terminal:

```bash
docker --version
```

You should see a valid Docker version printed.

If Docker is not running (rare), start it with:

```bash
sudo service docker start
```

---

## 🔧 Step 3 — Make the Build Script Executable

```bash
chmod +x build_pillow.sh
```

---

## 🧱 Step 4 — Build Pillow 11.3.0

Run:

```bash
bash build_pillow.sh 11.3.0
```

This script will:

1. Download Pillow source code (`Pillow-11.3.0.tar.gz`)
2. Launch the official `manylinux2014_x86_64` container
3. Install required system libraries inside the container:

   * libjpeg
   * zlib
   * libpng
   * freetype
   * lcms2
   * libwebp
   * harfbuzz
   * fribidi
4. Use **CPython 3.11** from `/opt/python/cp311-cp311`
5. Build the wheel
6. Run `auditwheel repair` to make it manylinux2014-compliant
7. Save the final wheel to `./dist/`

---

## 📦 Step 5 — Locate the Built Wheel

After the script finishes, you should see:

```bash
ls dist/
```

Example output:

```
pillow-11.3.0-cp311-cp311-manylinux2014_x86_64.whl
```

This is the **final artifact**.

---

## 🧪 (Optional) Step 6 — Test the Wheel Inside Codespaces

You can sanity-check the wheel:

```bash
python3 -m venv testenv
source testenv/bin/activate
pip install dist/pillow-11.3.0-*.whl
python -c "import PIL; print(PIL.__version__)"
```

Expected output:

```
11.3.0
```

---

## 📤 Step 7 — Transfer the Wheel to Another Machine

Download the wheel from Codespaces (right-click → Download), then upload to your target system (e.g., HPC cluster):

```bash
scp pillow-11.3.0-*.whl user@remote:/path/
```

Install it there with:

```bash
pip install pillow-11.3.0-*.whl
```

No compilation will occur.

---

## 🧠 Why This Works

* `manylinux2014` guarantees ABI compatibility across Linux distros
* `auditwheel` embeds shared libraries
* Pillow’s C extensions are compiled once, correctly
* Target systems never need a compiler or headers

This approach is **robust**, **portable**, and **HPC-friendly**.

---

## 📝 Notes

* This workflow is reusable for **other C-extension Python packages**
* The same structure can be adapted for:

  * OpenCV
  * PyTorch extensions
  * Scientific / robotics libraries
