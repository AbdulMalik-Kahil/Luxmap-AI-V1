
# ========== 1. التحقق من الحالة الحالية ==========
echo "🔍 التحقق من remote الحالي..."
git remote -v

# ========== 2. تنظيف و إعادة تهيئة remote ==========
echo "🧹 تنظيف remote القديم..."
git remote remove origin 2>/dev/null

echo "➕ قم بعمل تهيئة init.."
git init
echo "➕ إضافة remote جديد..."
git remote add origin https://github.com/AbdulMalik-Kahil/Luxmap-AI-V1.git

# ========== 3. التحقق من remote الجديد ==========
echo "✅ التحقق من remote الجديد..."
git remote -v

# ========== 4. تعيين main branch ==========
echo "🌿 تعيين main branch..."
git branch -M main

# ========== 5. التحقق من الـ branch ==========
echo "📍 الـ branch الحالي:"
git branch

# ========== 6. التحقق من status ==========
echo "📊 حالة الملفات:"
git status

# ========== 7. إضافة جميع الملفات ==========
echo "📦 إضافة جميع الملفات..."
git add .

# ========== 8. أول commit ==========
echo "💾 إنشاء أول commit..."
git commit -m "Initial commit: AI Agent setup with Terraform and GCP integration"

# ========== 9. ارفع الكود إلى GitHub ==========
echo "🚀 رفع الكود إلى GitHub..."
git push -u origin main
# بحالة الكود علق وصار مشكلة استخد الرفع بالقوة مع الاستبدال
git rebase --abort
git push -u origin main --force

# ========== 10. التحقق من النجاح ==========
echo "✨ تحقق من النتائج:"
git log --oneline -5
