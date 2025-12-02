// Sample data: based on your menu
const week = [
  {
    day: "Segunda-feira",
    meals: {
      breakfast: [{name:"Banana", qty:100, unit:"g", kcalPer100:89},
                  {name:"Leite", qty:200, unit:"ml", kcalPer100:60}],
      lunch: [{name:"Arroz integral", qty:120, unit:"g", kcalPer100:130},
              {name:"Feijão carioca", qty:100, unit:"g", kcalPer100:110},
              {name:"Frango grelhado", qty:120, unit:"g", kcalPer100:165},
              {name:"Salada", qty:120, unit:"g", kcalPer100:25},
              {name:"Suco caju", qty:200, unit:"ml", kcalPer100:45}],
      snack: [{name:"Maçã", qty:1, unit:"un", kcalPer100:52}],
      dinner: [{name:"Cuscuz", qty:150, unit:"g", kcalPer100:120},
               {name:"Ovo", qty:2, unit:"un", kcalPer100:70},
               {name:"Legumes", qty:50, unit:"g", kcalPer100:20}]
    }
  },
  // Add the other days (Terça..Domingo) following the same structure
];

// render
const menuEl = document.getElementById("menu");
function renderMenu() {
  menuEl.innerHTML = "";
  week.forEach(day => {
    const card = document.createElement("div");
    card.className = "day-card";
    card.innerHTML = `<h3>${day.day}</h3>`;
    for (const [mealName, items] of Object.entries(day.meals)) {
      const mealDiv = document.createElement("div");
      mealDiv.className = "meal";
      mealDiv.innerHTML = `<div><strong>${capitalize(mealName)}</strong><div class="small">${items.map(i => `${i.name} (${displayQty(i)})`).join(" • ")}</div></div><div class="small" id="${day.day}-${mealName}-kcal">-- kcal</div>`;
      card.appendChild(mealDiv);
    }
    menuEl.appendChild(card);
  });
}
function capitalize(s){ return s.charAt(0).toUpperCase()+s.slice(1) }
function displayQty(i){
  return i.unit==="g"||i.unit==="ml" ? `${i.qty}${i.unit}` : `${i.qty} ${i.unit}` 
}

// calculate kcal per meal/day and aggregated shopping list
function calculate() {
  const shopping = {}; // name -> {qty, unit}
  const results = [];
  week.forEach(day => {
    let dayTotal = 0;
    for (const [mealName, items] of Object.entries(day.meals)) {
      let mealKcal = 0;
      items.forEach(it => {
        let kcal = 0;
        if (it.unit === "g" || it.unit === "ml") {
          kcal = (it.kcalPer100 * it.qty) / 100.0;
        } else if (it.unit === "un") {
          // if unit, use qty * kcalPer100 (per unit preconfigured)
          kcal = it.kcalPer100 * it.qty;
        }
        mealKcal += kcal;
        // aggregate shopping quantities (g/ml/un)
        if (!shopping[it.name]) shopping[it.name] = {qty:0, unit: it.unit};
        shopping[it.name].qty += it.qty;
      });
      // show on card
      const el = document.getElementById(`${day.day}-${mealName}-kcal`);
      if (el) el.textContent = `${Math.round(mealKcal)} kcal`;
      dayTotal += mealKcal;
    }
    results.push({day: day.day, kcal: Math.round(dayTotal)});
  });
  // render shopping
  renderShopping(shopping, results);
}

function renderShopping(shopping, results) {
  const listEl = document.getElementById("shoppingList");
  listEl.innerHTML = "";
  const header = document.createElement("div");
  header.className = "table";
  header.innerHTML = `<div><strong>Item</strong></div><div><strong>Qty</strong></div><div><strong>Est. Cost (R$)</strong></div>`;
  listEl.appendChild(header);
  
  // price table (editable)
  const pricePerKg = {
    "Arroz integral": 7.5, "Arroz branco": 6.0, "Feijão carioca": 7.0, "Feijão preto":7.0,
    "Macarrão":5.0, "Cuscuz":6.0, "Batata-doce":4.5, "Inhame":8.0, "Macaxeira":4.0,
    "Frango grelhado":15.0, "Peixe":18.0, "Charque":25.0, "Sardinha":12.0
  };
  let totalCost = 0;
  for (const [name, obj] of Object.entries(shopping)) {
    let cost = 0;
    if (obj.unit === "g") {
      const ppkg = pricePerKg[name] || 6.0;
      cost = (obj.qty / 1000.0) * ppkg;
    } else if (obj.unit === "ml") {
      const pricePerL = 5.0;
      cost = (obj.qty / 1000.0) * pricePerL;
    } else { // un
      const perUnit = 1.0;
      cost = obj.qty * perUnit;
    }
    totalCost += cost;
    const row = document.createElement("div");
    row.className = "table";
    row.innerHTML = `<div>${name}</div><div>${formatQty(obj.qty,obj.unit)}</div><div>R$ ${cost.toFixed(2)}</div>`;
    listEl.appendChild(row);
  }
  document.getElementById("totalCost").innerHTML = `<h3>Custo estimado: R$ ${totalCost.toFixed(2)}</h3>`;
  
  // show day totals
  const totalsSection = document.createElement("div");
  totalsSection.style.marginTop = "12px";
  totalsSection.innerHTML = `<h3>Calorias por dia</h3>${results.map(r => `<div>${r.day}: ${r.kcal} kcal</div>`).join("")}`;
  listEl.appendChild(totalsSection);
}

function formatQty(q, unit) {
  if (unit==="g" && q>=1000) return (q/1000).toFixed(2)+" kg";
  if (unit==="ml" && q>=1000) return (q/1000).toFixed(2)+" L";
  return q + " " + unit;
}

document.getElementById("calcBtn").addEventListener("click", calculate);
document.getElementById("exportCsv").addEventListener("click", () => {
  alert("Export CSV ainda não implementado — posso gerar para você se quiser.");
});

// initial render
renderMenu();
