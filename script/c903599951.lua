--沈黙の邪悪霊
function c903599951.initial_effect(c)
	--Activate
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_ACTIVATE)
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(c903599951.redirectattackcon)
	--e1:SetTarget(c93599951.target)
	--e1:SetOperation(c903599951.redirectattackop)
	--c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(90901451,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCondition(c90901451.condition)
	e2:SetCondition(c903599951.cbcon)
	--e2:SetCost(c903599951.costLP)
	e2:SetTarget(c903599951.target)
	e2:SetOperation(c903599951.activate)
	c:RegisterEffect(e2)
end
function c903599951.sfilter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsFaceup()--c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function c903599951.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=Duel.GetAttackTarget()
	return bt and bt:IsControler(tp)
end
--effect 1
function c903599951.costLP(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500*c903599951.counterdamag) end
	Duel.PayLPCost(tp,(500*c903599951.counterdamag))
end
function c903599951.negcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() --and Duel.IsExistingMatchingCard(c903599951.sfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c903599951.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local a=Duel.GetAttacker()
	if chk==0 then return a and a:IsCanBeEffectTarget(e) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,a) end
	Duel.SetTargetCard(a)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,a)
	c903599951.counterdamag = 2
	e:SetLabelObject(g:GetFirst())
end
function c903599951.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsFacedown()) then
		if tc:IsDefencePos() then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
		--Duel.ChangeAttacker(tc)
		Duel.ChangeAttackTarget(tc)
	end
end
