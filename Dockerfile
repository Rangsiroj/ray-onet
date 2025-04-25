# FROM continuumio/miniconda3

# # สร้าง working directory
# WORKDIR /app

# # คัดลอกไฟล์ environment.yaml เข้าไปใน container
# COPY environment.yaml .

# # สร้างและ activate conda environment
# RUN conda env create -f environment.yaml
# SHELL ["conda", "run", "-n", "rayonet", "/bin/bash", "-c"]

# # คัดลอก source code ทั้งหมดเข้าไป
# COPY . .

# # คอมไพล์ extension modules
# RUN python setup.py build_ext --inplace

# CMD ["conda", "run", "--no-capture-output", "-n", "rayonet", "python", "demo/demo.py"]


FROM continuumio/miniconda3

WORKDIR /app

# คัดลอก environment.yaml
COPY environment.yaml .

# สร้าง environment ชื่อ rayonet
RUN conda env create -f environment.yaml

# ติดตั้ง g++ และ python-dev (บาง extension ต้องใช้ตอน compile)
RUN apt-get update && apt-get install -y build-essential

# ตั้ง shell สำหรับคำสั่ง conda run
SHELL ["conda", "run", "-n", "rayonet", "/bin/bash", "-c"]

# คัดลอกไฟล์โปรเจกต์ทั้งหมด
COPY . .

# คอมไพล์ extension modules
RUN python setup.py build_ext --inplace

# คำสั่งรัน train.py แทน demo
CMD ["conda", "run", "--no-capture-output", "-n", "rayonet", "python", "train.py"]
