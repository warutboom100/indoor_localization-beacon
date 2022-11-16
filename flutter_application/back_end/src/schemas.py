from typing import List
import datetime as _dt
from numpy import double
import pydantic as _pydantic



class _weightposition(_pydantic.BaseModel):
    mean_pos_x: float
    std_pos_x: float
    mean_pos_y: float
    std_pos_y: float
    

class weightposition_create(_weightposition):
    pass

class _weightdistance(_pydantic.BaseModel):
    mean_dist1: float
    std_dist1: float
    mean_dist2: float
    std_dist2: float
    mean_dist3: float
    std_dist3: float
    mean_dist4: float
    std_dist4: float
    mean_dist5: float
    std_dist5: float

class weightdistance_create(_weightdistance):
    pass


class _Datadist(_pydantic.BaseModel):
    dist1: float
    dist2: float
    dist3: float
    dist4: float
    dist5: float

class Distcreate(_Datadist):
    pass

class _PostBase(_pydantic.BaseModel):
    RSSI1: float
    RSSI2: float
    RSSI3: float
    RSSI4: float
    RSSI5: float
    

class _PostBase1(_pydantic.BaseModel):
    position_x: float
    position_y: float


class PostCreate(_PostBase):
    pass


class Post(_PostBase):
    id: int
    owner_id: str
    date_created: _dt.datetime
    date_last_updated: _dt.datetime

    class Config:
        orm_mode = True

class PostCreate1(_PostBase1):
    pass


class Post1(_PostBase1):
    id: int
    owner_id: str
    is_active: bool
    date_created: _dt.datetime
    date_last_updated: _dt.datetime

    class Config:
        orm_mode = True

class _UserBase(_pydantic.BaseModel):
    deviceID: str


class UserCreate(_UserBase):
    pass


class User(_UserBase):
    id: int
    is_active: bool
    posts: List[Post] = []

    class Config:
        orm_mode = True


class User_position(_UserBase):
    id: int
    is_active: bool